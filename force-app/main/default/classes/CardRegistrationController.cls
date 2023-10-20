public with sharing class CardRegistrationController {
    
    @AuraEnabled
    public static void stripeCardAuthentication(String cardNumber, Integer expMonth, Integer expYear, String cvc)
    {
        try 
        {
            // Create an instance of AuthNetGetCustomerIDToCardInfo
            // We are doing this because Non static method cannot be referenced from a static context
            // Non Static context for generateAuthNetCustomerId is due to its private variables
            StripeGetTokenID stripeInstance = new StripeGetTokenID();

            // Call the generateAuthNetCustomerId method on the instance
            StripeGetCustomerIDWrapper stripeResponse = stripeInstance.createStripeToken(cardNumber, expMonth, expYear, cvc);
            if(stripeResponse.error == null)
            {
                System.debug('New Customer Profile Id::'+stripeResponse.id);
               
            }
            // Handle the case where the authentication with Authorize.Net resulted in an error
            else if(stripeResponse.error != null)
                {
                    System.debug('Error::'+stripeResponse.error.message);
                }
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}