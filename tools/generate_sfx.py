"""
Life Quest — SFX Generator
Generates battle sound effects as WAV files using pure Python (no external libs).
Uses numpy if available, otherwise pure math with struct.
"""

import math
import os
import struct
import wave

OUT_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'sounds', 'sfx')
os.makedirs(OUT_DIR, exist_ok=True)

SAMPLE_RATE = 44100


def write_wav(filename, samples, sample_rate=SAMPLE_RATE):
    """Write a list of float samples [-1, 1] to a WAV file."""
    out_path = os.path.join(OUT_DIR, filename)
    n = len(samples)
    with wave.open(out_path, 'w') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)  # 16-bit
        wf.setframerate(sample_rate)
        packed = struct.pack(f'<{n}h', *[max(-32768, min(32767, int(s * 32767))) for s in samples])
        wf.writeframes(packed)


def silence(duration):
    return [0.0] * int(SAMPLE_RATE * duration)


def sine(freq, duration, amp=1.0, phase=0.0):
    n = int(SAMPLE_RATE * duration)
    return [amp * math.sin(2 * math.pi * freq * i / SAMPLE_RATE + phase) for i in range(n)]


def noise(duration, amp=1.0):
    import random
    rng = random.Random(42)
    n = int(SAMPLE_RATE * duration)
    return [amp * (rng.random() * 2 - 1) for _ in range(n)]


def envelope(samples, attack=0.01, decay=0.05, sustain=0.7, release=0.1):
    """ADSR envelope."""
    n = len(samples)
    sr = SAMPLE_RATE
    a = int(attack * sr)
    d = int(decay * sr)
    r = int(release * sr)
    result = []
    for i, s in enumerate(samples):
        if i < a:
            gain = i / a
        elif i < a + d:
            gain = 1.0 - (1.0 - sustain) * (i - a) / d
        elif i < n - r:
            gain = sustain
        else:
            gain = sustain * (1 - (i - (n - r)) / r)
        result.append(s * gain)
    return result


def mix(*tracks):
    """Mix multiple sample lists together (normalised)."""
    max_len = max(len(t) for t in tracks)
    result = [0.0] * max_len
    for track in tracks:
        for i, s in enumerate(track):
            result[i] += s
    peak = max(abs(s) for s in result) or 1.0
    return [s / peak * 0.9 for s in result]


def fade_out(samples, duration=0.05):
    n = len(samples)
    fade_n = int(duration * SAMPLE_RATE)
    result = list(samples)
    for i in range(min(fade_n, n)):
        result[n - 1 - i] *= i / fade_n
    return result


# ---------------------------------------------------------------------------
# SFX definitions
# ---------------------------------------------------------------------------

def make_attack_swing():
    """Sword swing — whoosh + metallic impact."""
    dur = 0.35
    # Whoosh: filtered noise, pitch sweeps down
    whoosh = []
    n = int(SAMPLE_RATE * dur)
    import random
    rng = random.Random(1)
    for i in range(n):
        t = i / SAMPLE_RATE
        prog = i / n
        freq = 800 - prog * 600  # sweep 800→200 Hz
        s = math.sin(2 * math.pi * freq * t) * 0.4
        s += (rng.random() * 2 - 1) * 0.2 * (1 - prog)
        gain = math.sin(math.pi * prog) * (1 - prog * 0.5)
        whoosh.append(s * gain)

    # Metallic ping at impact (60% through)
    ping = sine(1200, 0.12, amp=0.6) + sine(2400, 0.06, amp=0.3)
    ping = envelope(ping, attack=0.001, decay=0.04, sustain=0.2, release=0.07)
    offset = int(0.18 * SAMPLE_RATE)
    combined = list(whoosh)
    for i, s in enumerate(ping):
        if offset + i < len(combined):
            combined[offset + i] += s

    return fade_out(combined, 0.04)


def make_defend():
    """Shield raise — solid thud + brief resonance."""
    # Thud (low frequency punch)
    thud = sine(80, 0.15, amp=0.8) + sine(140, 0.12, amp=0.5)
    thud = envelope(thud, attack=0.002, decay=0.08, sustain=0.1, release=0.06)

    # Metal clang overtones
    clang = sine(440, 0.25, amp=0.4) + sine(880, 0.15, amp=0.3)
    clang = envelope(clang, attack=0.002, decay=0.06, sustain=0.3, release=0.12)

    # Small noise burst
    n_burst = noise(0.04, amp=0.4)
    n_burst = envelope(n_burst, attack=0.001, decay=0.02, sustain=0.1, release=0.01)

    combined = mix(thud + silence(0.1), clang, n_burst + silence(0.21))
    return fade_out(combined, 0.05)


def make_magic_cast():
    """Magic projectile — ascending shimmer + launch whoosh."""
    dur = 0.5

    # Rising shimmer arpeggiation
    shimmer = []
    freqs = [440, 554, 659, 880, 1109]
    step = dur / len(freqs)
    for f in freqs:
        part = sine(f, step * 0.7, amp=0.5)
        part = envelope(part, attack=0.02, decay=0.05, sustain=0.6, release=0.1)
        shimmer.extend(part + silence(step * 0.3))

    # Continuous hum underneath
    hum = sine(220, dur, amp=0.3)
    hum2 = sine(330, dur, amp=0.2)
    hum_env = envelope(hum, attack=0.05, decay=0.1, sustain=0.5, release=0.15)
    hum2_env = envelope(hum2, attack=0.05, decay=0.1, sustain=0.5, release=0.15)

    combined = mix(shimmer[:len(hum_env)], hum_env, hum2_env)
    return fade_out(combined, 0.06)


def make_magic_hit():
    """Magic impact — burst + reverb tail."""
    # Initial burst
    burst = noise(0.08, amp=0.7)
    burst_tone = sine(660, 0.08, amp=0.5) + sine(990, 0.06, amp=0.3)
    burst_env = envelope(burst + [0]*int(0.05*SAMPLE_RATE),
                         attack=0.002, decay=0.04, sustain=0.2, release=0.04)
    burst_t_env = envelope(burst_tone + [0]*int(0.05*SAMPLE_RATE),
                           attack=0.002, decay=0.04, sustain=0.2, release=0.04)

    # Reverb tail (decaying sine cluster)
    tail = []
    tail_dur = 0.4
    for f, a in [(330,0.3),(495,0.25),(660,0.2),(880,0.15)]:
        t = sine(f, tail_dur, amp=a)
        t = envelope(t, attack=0.01, decay=0.15, sustain=0.1, release=0.25)
        if not tail:
            tail = t
        else:
            for i in range(min(len(tail), len(t))):
                tail[i] += t[i]

    combined = mix(
        burst_env + tail,
        burst_t_env + [0]*len(tail),
    )
    return fade_out(combined, 0.06)


def make_enemy_death():
    """Enemy defeated — dramatic explosion + fade."""
    # Low boom
    boom = sine(60, 0.3, amp=0.8)
    boom_env = envelope(boom, attack=0.004, decay=0.1, sustain=0.3, release=0.15)

    # Noise burst
    n_burst = noise(0.2, amp=0.6)
    n_env = envelope(n_burst, attack=0.003, decay=0.08, sustain=0.2, release=0.09)

    # High-pitched screech
    screech = sine(800, 0.15, amp=0.4) + sine(1200, 0.1, amp=0.3)
    screech_env = envelope(screech, attack=0.002, decay=0.05, sustain=0.2, release=0.08)

    # Descending pitch sweep
    sweep = []
    n = int(0.4 * SAMPLE_RATE)
    for i in range(n):
        prog = i / n
        freq = 400 * (1 - prog * 0.85)
        sweep.append(math.sin(2 * math.pi * freq * i / SAMPLE_RATE) * (1 - prog) * 0.5)

    combined = mix(
        boom_env + silence(0.1),
        n_env + silence(0.1),
        screech_env + silence(0.15),
        sweep,
    )
    return fade_out(combined, 0.1)


def make_level_up():
    """Level up fanfare — ascending arpeggio + flourish."""
    # Ascending notes
    notes = [(262,0.12),(330,0.12),(392,0.12),(523,0.12),(659,0.12),(784,0.25)]
    parts = []
    for freq, dur in notes:
        p = sine(freq, dur, amp=0.6)
        p2 = sine(freq*2, dur, amp=0.2)
        part = [a+b for a,b in zip(p,p2)]
        part = envelope(part, attack=0.01, decay=0.04, sustain=0.7, release=0.04)
        parts.extend(part)

    # Final chord
    chord = []
    for f in [523, 659, 784, 1047]:
        p = sine(f, 0.6, amp=0.4)
        p = envelope(p, attack=0.02, decay=0.1, sustain=0.6, release=0.2)
        if not chord:
            chord = p
        else:
            chord = [a+b for a,b in zip(chord, p)]

    combined = parts + chord
    peak = max(abs(s) for s in combined) or 1.0
    return [s / peak * 0.88 for s in combined]


def make_card_play():
    """Card played — soft whoosh + paper flutter."""
    import random
    rng = random.Random(10)
    dur = 0.2
    n = int(SAMPLE_RATE * dur)
    samples = []
    for i in range(n):
        prog = i / n
        freq = 200 + prog * 600
        s = math.sin(2 * math.pi * freq * i / SAMPLE_RATE) * 0.3
        s += (rng.random() * 2 - 1) * 0.15 * (1 - prog)
        gain = math.sin(math.pi * prog)
        samples.append(s * gain)
    return fade_out(samples, 0.03)


def make_button_click():
    """UI button click — crisp tick."""
    click = sine(1000, 0.04, amp=0.5)
    click2 = sine(1500, 0.02, amp=0.3)
    combined = [a + b for a, b in zip(click, click2 + [0]*int(0.02*SAMPLE_RATE))]
    return envelope(combined, attack=0.001, decay=0.02, sustain=0.1, release=0.01)


def make_victory():
    """Victory jingle — cheerful 8-bit style."""
    melody = [
        (523,0.1),(659,0.1),(784,0.1),(1047,0.15),
        (784,0.08),(880,0.08),(1047,0.3),
    ]
    parts = []
    for freq, dur in melody:
        p = sine(freq, dur, amp=0.5)
        # Add a slight square-wave character
        p2 = [math.copysign(0.2, s) for s in p]
        part = [a + b for a, b in zip(p, p2)]
        part = envelope(part, attack=0.005, decay=0.03, sustain=0.8, release=0.03)
        parts.extend(part)
    peak = max(abs(s) for s in parts) or 1.0
    return [s / peak * 0.85 for s in parts]


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
SFX = [
    ('attack_swing.wav',    make_attack_swing),
    ('defend_block.wav',    make_defend),
    ('magic_cast.wav',      make_magic_cast),
    ('magic_hit.wav',       make_magic_hit),
    ('enemy_death.wav',     make_enemy_death),
    ('level_up.wav',        make_level_up),
    ('card_play.wav',       make_card_play),
    ('button_click.wav',    make_button_click),
    ('victory.wav',         make_victory),
]

if __name__ == '__main__':
    print('Life Quest \u2014 SFX Generator \uc2dc\uc791')
    count = 0
    for filename, fn in SFX:
        try:
            samples = fn()
            write_wav(filename, samples)
            dur = len(samples) / SAMPLE_RATE
            print(f'  \u2713 {filename:30s} ({dur:.2f}s)')
            count += 1
        except Exception as e:
            import traceback
            print(f'  [!] {filename}: {e}')
            traceback.print_exc()
    print(f'\n\uc644\ub8cc: {count}\uac1c SFX \uc0dd\uc131 \u2192 {OUT_DIR}')
