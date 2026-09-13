// Dedicated synthetic QA entry point. Never upload this target to Play.
import 'dart:async';
import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:life_quest_final_v2/features/backup/device_backup.dart';
import '../test/features/backup_fixture.dart';

const enabled = bool.fromEnvironment('LIFEQUEST_NATIVE_BACKUP_PROBE');
const portableFixture =
    'eyJmb3JtYXQiOiJsaWZlcXVlc3QtZW5jcnlwdGVkLWJhY2t1cCIsInZlcnNpb24iOjEsImFsZ29yaXRobSI6InBia2RmMi1zaGEyNTYtNjAwMDAwLWFlczI1NmdjbSIsInNhbHQiOiI4RlR3RkdqTlhkaHExcVFiR3hCWWpnPT0iLCJub25jZSI6IlpoSEpub0cvTDBPWWNyM24iLCJjaXBoZXJ0ZXh0IjoiUE9hYk5nN0U1UWYra1NkTCtsbXkvOW5iRWdwZC9FM0RZQXhVNkZad1RMdTlUTlNwL214SGt5NmtjeWlTanoxK09yVE40cnhRd3Q3L1l6TGpDQ2JrMnd6TEtDTlFaVkhiTkdTMlZ4VlFncGg2UlBSR0R1bTFneTVGY0lQM01rdGRKUjcvZ1hQck81MXRwVlliNi9CRU80NmQ0bWU4WHFRanhVeFlVV2tFd2JsMGNQb1VKK1pMSktjYmlwQXQzWlVvcUdQMFB6ZjZ5eWZHbUtJWFJERjR0MTkrRGRINzBEVU5pdGpEaWV5TUZFYjAweGdUSlY5RGxTNDRLakhrQmV6K2pHNHVYWEVMTnlWMk4wdnQzNHlMQjdYUldMZ1FKN2VtbS9vcndteVM2VXBCR09kaDJUZTRDS2RRU2R4SWZ3cHBleGdjeEl2TUhTNkxtNkp5MGtuU0xIaWNscGF5cXBVWTMyK1pDVU1VK2FQMytrdkllQVkvRFp5UGpXOW5RNjd1ZW9sdXR4eEcxVVdqMkJOYTVMVXYzbndRUVVPTUhqUjVDRnA0aWsvRnJPRDRHZnpEYnowUyt3VkJjWEV3V0QvYkVwNnNCa21LRU5uZHdTYm0zYmtWV0N3MkMzZGVHMDV5R0tHamZJSmRRazFMNUl2RDBQUWtSVDdMaFdWbm91UVU3dVB1bXJ5eXhocTNna2hJNzdtRk9IU05odVNyVm9PMmEzQTNYUmFFT0Q3OXhZVXcwcFZNS1JaT25kNTNoaXhuZnhub1c1SHFMTGpGajJYY0lCUmNmTmtiend4VmgzbnFISzU2Q3hwSjM5ZXc1bmJ4diszUzFKYVlkZnphdjRpRm9RMm04Nk5nQ3NVZkVuQlNzSE9hSW8wU3pxaytvbHlFNmxmZXJNL2I1M2IyQWlTRFhhbWlaTHp0dFUwR3VMd2REZWx4eXUxYndHMWp2cWUySVZDMXE1bHRpd0F0Z1dQcW0yZFRyRk00aDloZ1JYMzlQUENZOTN3Zy9udU1jN3hFeDA3cm1uYlhnalFWb1kzWC8vTjFsTFR4NHhYZGRMU1BQYjEwdmRyd0hnSFAyUVdHdGdhUUlTVWw5ODlsNEdCb0JuMEVlQXlHVi9hQkdlZ1RQR2oxQW4zQUN6WitjZWVBTTE4TzJjalhUUjBxMmFtbko5S2dKbENlWFpPZTZMYlFWYUcxOHNsVHl1ZGNVaEp3emY4WlY0Mlg3N2RZaitMQTJCcjNnVGdQTWpIbjluZW82OEQyNFZYSkFubjRwSUZFSEJaSWhPaEhhNGU3QVpzNzdvUnBCZDI4YkszK3lWMWZPckpqNmVjUUpMZlo3dDNlOGdLM1dwczQrT2ZNcmFwR1NML1pCTDlsb3pGVEFkT3YwYWoxdStzc1Aya1g1TnFGY0c4c0xJY2lqQVBONE5yRUZqOVBEL2I0Vlp6MXJjWTNrSlNweElaeExmMllQYVZoMTBPckJSc1ZQSnJ0dzVnNW9uV2pqNkp6STBFYk1UbUx5M1hFT0h4MGd2SmNvWmtFQm9lSThhWDNZWE1CdzkreTdieHN1dUx5M0ZWSElLd1Uyc2dlSjM5cVlramEwNVp5dXJvaDk1Wk9RRFhhOWg5L2thaS9QSkdhOTFvZGo3WDIvM2U3TDBUTmQrVnJVVWtWSGZETDZ4eFZJQTJuUUREK29EcW1GVmVGYklWTjJPNHNVWHhpZ04rRXFFbGdJT0ppZ3Fra1VVWUptVURVUE5hODJVZzE5d2FqaGRuQ0kwcTN5V2ZsUHVOYVJjUnRGditycnBaNGVXdXUwN1JTSFhreUtuc1lManRDT2ZIWmdwSzJ4andaUmpOZ0grbjgxQWFhTDZaQ1pSaDFYWDhzSk1XLzBwS3JpNk5iK0l5bVF3NUk1eVovSW1oYnJta1NBSnljQ1c0WmJVTUphOTMrOHNKSVM0VWhBUHVWeEk5WHd3NW82eVlTZ2E5dy9Lbkw1K214TVpqUEVkNmpPRi92Z3owZHJ6N2Z4NkFlUDBIWWZ3TEloMERHYWM1bGJCN1IzQWx4ejBMdFRGU3FMK2tDUzdyVG9GdUNucHo1dWl0SThsMXZvSlRISkg5SVBHMHJjVWtmVklkVVJnUW45NWhhNWo0UnpreDJxc0o3Ymx1WHBqNjlyV0Ewc0hjWmpkbkRxSFIwekZyWFhRTzBiV3YxUUI3enpwWkx5TlJUZ0FXS2g1M1VuVFp0dHhJOTNUNzh0V3NiTVU3eks0NXlyVjBqQTNCeXIyTHdKL2k2NVdnekQ2M0hKQmJZQ2c2ZFFGL2FwSVdYYkR3MVB2VEUyamd3dTZmTXI1M3V2MXA4MWFtTVhhTFhyeHd4bTJnaVVxQUFYMUdXb3dhMmh6cXBvWnVZc2JlT2ozbWdCT0JYNHRLOXQ1bkVwYnZMSDJNTHlVd3ZIWTFEd0loY3JadWlqZTAwNS9TZjF6QWppL0hZVWx5MkMrYkRMY21vU3BiTlp5dit3cXF3OE5MZ1hRSmVMWmxLenBpRnNhRU0vZUNrWlZocmlGUUhXQmRxV3FUbUloeTNVSVFTdzh0R1Y3b3NKME5GVmpPaFZ2cW1icUdDWGowOHBCWHZFNUwxQVV3VGRvTjBLVFFOS0lZZms4NXBBdnYzb3ZmRlBjUHBieVNTZVM4b3RIc1ZoaDRSbTAwWk9xWjFFK2pHZC9LZnVrcFVRdVhVU2xOMWh0MXJORGZ6MWMxZlY2VWh6L1JYaFJ2d0xLYWJuUHlIWGpnblB4QkFocVAzbXFOWnhlOWY5SEhnZ2t1dEtWWTF6dmQ4TWhDbEd6dG1JRG8zcURXOGkyTSsrSVpKMGFSWi9JcDFBdENOT1pDQ3lNY1NsL0QzMDVRbXkwUjZvTmZGc1hvWm5vVGxjWERvTTgwZnNZaDJiTEIvVFVzeVhVNTB5Tm1oL3NXbE5rUFcwUnIyem4vTC8xTFd5WHhVUGduNkpaUzluSUZCTC9aM0NEejhrZTFwdWZaQ0lZaytwekU2Ry9Md1BtZlBpRGlJRm41bDNBWDlsL1hENlhCck9taHJ0SkROeVRXQUQyY1p2RmRQdFpENnpFQ01zRzlrdDNWeFo5K1J6bytFeWpMNm5oNXpoWXF1WlRwZEprMTFta1oxbDBRc2NMUjd1Znordkt5T0tnUFN3eC9lVjBhRHJXYzVEbFcwNHNXZnJOd3BSZ2lTMjJCYldnTGVMOFNDeHhpN0NuR0dyYkFtWDlXbnBPOFh0b2ZBZ1ZuUFI1ZGJLc0ZrNkRDaWlzY0MwY3VUelc1TUJ6ZjhDYjBNd1NJR01vU0xlRFpXWlMrVUpwQmNrTVJzWlErYmVZRjgiLCJ0YWciOiIvR3VJZHZIZWhxTG01TGZyeHdzdjZBPT0ifQ==';
final status = ValueNotifier<String>('Checking encrypted backup');
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!enabled) throw StateError('Explicit QA opt-in required.');
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: status,
            builder: (_, value, _) => Text(value),
          ),
        ),
      ),
    ),
  );
  unawaited(probe());
}

Future<void> probe() async {
  try {
    const password = '서랍 속에 보관하는 긴 암호 🌿';
    final codec = DeviceBackupCodec();
    final watch = Stopwatch()..start();
    final decoded = await codec.decrypt(
      base64Decode(portableFixture),
      password,
    );
    if (decoded.name != '검증용 각성자') throw StateError('Fixture mismatch');
    final decryptMs = watch.elapsedMilliseconds;
    watch.reset();
    final encrypted = await codec.encrypt(backupFixture(), password);
    final encryptMs = watch.elapsedMilliseconds;
    final roundTrip = await codec.decrypt(encrypted, password);
    if (roundTrip.director['profile']['goal'] != '퇴근 후 조용한 영어 공부') {
      throw StateError('Round trip mismatch');
    }
    // Synthetic test data only. Chunked to avoid Android's log entry limit.
    final encoded = base64Encode(encrypted);
    for (var i = 0; i < encoded.length; i += 500) {
      final end = i + 500 < encoded.length ? i + 500 : encoded.length;
      // ignore: avoid_print
      print(
        'LIFEQUEST_BACKUP_FIXTURE=${i ~/ 500}:${encoded.substring(i, end)}',
      );
    }
    // ignore: avoid_print
    print(
      'LIFEQUEST_BACKUP_PROBE=${jsonEncode({'pass': true, 'backend': Cryptography.instance.runtimeType.toString(), 'decryptMs': decryptMs, 'encryptMs': encryptMs, 'fixtureLength': encrypted.length, 'fixtureSha256': (await Sha256().hash(encrypted)).bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()})}',
    );
    status.value = 'PASS · encrypted backup';
  } catch (error) {
    // ignore: avoid_print
    print(
      'LIFEQUEST_BACKUP_PROBE=${jsonEncode({'pass': false, 'error': error.runtimeType.toString()})}',
    );
    status.value = 'FAIL · backup probe';
  }
}
