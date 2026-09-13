/// Billing and ads have independent release gates. Selling a story/theme must
/// never silently enable advertising or paid experience boosts.
const bool kLifeQuestMonetizationEnabled = bool.fromEnvironment(
  'LIFEQUEST_MONETIZATION_ENABLED',
);
const bool kLifeQuestAdsEnabled = bool.fromEnvironment('LIFEQUEST_ADS_ENABLED');
