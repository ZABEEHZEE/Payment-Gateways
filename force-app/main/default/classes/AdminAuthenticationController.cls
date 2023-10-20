public with sharing class AdminAuthenticationController 
{
    //Method to authenticate Authorize.net Merchant account
    @AuraEnabled
    public static StripeAdminWrapper StripeAdminAuth(String stripeMerchantName, String stripeSecretApiKey, String stripePublishableApiKey )
    {
       
            StripeAdminWrapper stripeAPIResponse= AuthenticateStripeAdmin.authenticateStripeAdminAPI(stripeMerchantName, stripeSecretApiKey);
            System.debug('stripeAPIResponse::      '+stripeAPIResponse);
            System.debug('stripeAPIResponse Error::      '+stripeAPIResponse);
           
            // Check if the authentication with Stripe was successful (result code is 'Ok')
            


            if(stripeAPIResponse.error == null  )
            {
                system.debug('in first if ');
                if(stripeAPIResponse.Settings.dashboard.display_name == stripeMerchantName)
                {
                    system.debug('the  display name is correct and the merchant is authenticated');
                    // Retrieve the org-level default Custom Setting record for Stripe
                    logicpayment__Stripe_CustomSetting__c stripeCustomSetting = logicpayment__Stripe_CustomSetting__c.getOrgDefaults();

                    // Update the Custom Setting fields with the provided strip information
                    stripeCustomSetting.logicpayment__Merchant_Name__c = stripeMerchantName;
                    stripeCustomSetting.logicpayment__API_Secret_Key__c = stripeSecretApiKey;
                    stripeCustomSetting.logicpayment__API_Publishable_Key__c = stripePublishableApiKey;
                    system.debug(stripeCustomSetting);
                    upsert stripeCustomSetting;
                }
                else if(stripeAPIResponse.Settings.dashboard.display_name != stripeMerchantName)
                {
                    system.debug('display name is not correct');
                }
                
            }
            // Handle the case where the authentication with Stripe resulted in an error
            else if(stripeAPIResponse.error.message != null   )
            {
                
                String errorMessage = stripeAPIResponse.error.message;
                system.debug('api key is not correct : '+errorMessage);
                

            }
            return stripeAPIResponse;

    }

    
  
}