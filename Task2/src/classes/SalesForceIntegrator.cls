@RestResource(urlMapping='/SalesForceIntegrator/*')
global with sharing class SalesForceIntegrator {

    @HttpPost
    global static void upsertAccounts(String param){


        String s = '[{"attributes":{"type":"Account","url":"/services/data/v44.0/sobjects/Account/0017F00000phLVYQA2"},"Name":"SFDC Computing","Phone":"(415)555-1212","Id":"0017F00000phLVYQA2"}]';

        // {"param" : "What are you doing?"}
        // /services/apexrest/SalesForceIntegrator
        return;
    }

}