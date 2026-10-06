# Play purchase acknowledgement recovery

`verifyPurchase` queues the private `acknowledgePlayPurchase` task before committing an unacknowledged purchase grant. A queue outage returns an unavailable error and creates no new grant. After a durable grant, a failed immediate acknowledgement still returns the verified entitlement; Cloud Tasks continues without the app running. Every task attempt rechecks Google Play, account availability, token ownership and purchase state. Duplicate deliveries keep one entitlement; older jobs preserve a newer replacement grant. Refunds revoke the matching grant and deleted accounts terminate recovery.

The queue waits 60 seconds before the first attempt and retries temporary failures up to 300 attempts / 48 hours, with a 60–600 second backoff. Raw purchase tokens exist only in the restricted task payload and the publisher request. Firestore identifiers are hashes. Do not export task payloads, enable request-body logging, or put receipt values in logs.

Before enabling paid products, deployment must:

- Enable Cloud Tasks and deploy `acknowledgePlayPurchase` before the updated `verifyPurchase`. The Firebase CLI creates the queue from the function's retry configuration. No dependency installation is needed for this change.
- Keep the worker's `invoker: 'private'` setting. Grant only the trusted function runtime service account enqueue access to this queue and permission to act as the service account used by the task's OIDC token. That identity needs invocation access to the deployed second-generation worker (`roles/run.invoker`); verify no `allUsers` or `allAuthenticatedUsers` invocation binding exists.
- Keep the runtime's existing Android Publisher / Play Console verification and acknowledgement permissions. Use Application Default Credentials.
- Confirm an unauthenticated worker request is rejected, a real licensed test purchase is granted once, and an injected acknowledgement failure completes through the queue after the app exits. Alert on task failures/exhaustion and increasing queue age early enough to resolve the Play acknowledgement deadline. Unit tests do not verify live IAM, queue provisioning or store behavior.

No Firebase project, IAM role, queue or billing account was changed locally. Official references: [Firebase task queues and IAM](https://firebase.google.com/docs/functions/task-functions), [task queue options](https://firebase.google.com/docs/reference/functions/2nd-gen/node/firebase-functions.tasks.taskqueueoptions).
