/// Enable only after the Firebase project, package registration and rules have
/// been verified. The device profile never requires a cloud connection.
const bool kLifeQuestCloudEnabled = bool.fromEnvironment(
  'LIFEQUEST_CLOUD_ENABLED',
);
