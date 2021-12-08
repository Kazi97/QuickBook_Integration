global with sharing class QuickBook extends Auth.AuthProviderPluginClass {

    private String customMetadataTypeApi = 'QB_Metadata__mdt';
    public String redirect_url;
    private String access_token_url;
    private String auth_url;
    private String client_id;
    private String client_secret_key;
    private String realm_id;
    private String scope;
    // private String state;
    private String user_info_url;
    private String security_token;

    global String getCustomMetadataType(){
        return customMetadataTypeApi;
    }

    global Pagereference initiate(Map<String,String> authProviderConfiguration, String stateToPropagate){

        client_id = authProviderConfiguration.get('Client_Id__c');
        auth_url = authProviderConfiguration.get('Auth_Url__c');
        scope = authProviderConfiguration.get('Scope__c');
        redirect_url = authProviderConfiguration.get('Callback_URL__c');
        security_token = authProviderConfiguration.get('Security_Token__c');

        String urlToRedirect = auth_url+'?client_id='+client_id+'&scope='+scope+'&redirect_uri='+EncodingUtil.urlEncode(redirect_url, 'UTF-8')+'&response_type=code&state='+stateToPropagate;

        Pagereference pgref = new Pagereference(urlToRedirect);

        return pgref;
    }

    global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ){

        client_id = authProviderConfiguration.get('Client_Id__c');
        client_secret_key = authProviderConfiguration.get('Client_Secret__c');
        redirect_url = authProviderConfiguration.get('Callback_URL__c');
        access_token_url = authProviderConfiguration.get('Access_Token_Url__c');
        System.debug(access_token_url);
        Map<String,String> query = state.queryParameters;
        String code = query.get('code');
        String getState = query.get('state');

        String requestBody = 'grant_type=authorization_code&code='+code+'&redirect_uri='+redirect_url;    
        HttpRequest request = new HttpRequest();
        request.setEndpoint(access_token_url);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Host', 'oauth.platform.intuit.com');
        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(client_id+':'+client_secret_key)));
        request.setMethod('POST');
        request.setBody(requestBody);

        System.debug(requestBody);
        Http http = new Http();

        HttpResponse response = new HttpResponse();
        response = http.send(request);
        // String body = '';
        String body = response.getBody();
        System.debug(body);


        QB_Wrapper wrapper = (QB_Wrapper)System.JSON.deserialize(body, QB_Wrapper.class);

        return new Auth.AuthProviderTokenResponse('QuickBook',wrapper.access_token, wrapper.refresh_token, getState);
    }

    global override Auth.OAuthRefreshResult refresh(Map<String,String> authProviderConfiguration, String refreshToken){


        access_token_url = authProviderConfiguration.get('Access_Token_Url__c');
        client_id = authProviderConfiguration.get('Client_Id__c');
        client_secret_key = authProviderConfiguration.get('Client_Secret__c');

        System.debug(refreshToken);
        String requestBody = 'grant_type=refresh_token&refresh_token='+refreshToken;

        HttpRequest request = new HttpRequest();
        request.setEndpoint(access_token_url);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(client_id+':'+client_secret_key)));
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        Http http = new Http();

        HttpResponse response = new HttpResponse();
        response = http.send(request);
        String body = response.getBody();

        System.debug(body);

        QB_Wrapper wrapper = (QB_Wrapper)System.JSON.deserialize(body, QB_Wrapper.class);

        return new Auth.OAuthRefreshResult(wrapper.access_token, wrapper.token_type);
    }

    global Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response){
        
        user_info_url = authProviderConfiguration.get('User_Info_URL__c');
        HttpRequest request = new HttpRequest();
        request.setEndpoint(user_info_url);
        request.setHeader('Authorization', 'Bearer '+response.oauthToken);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        System.debug(response.oauthToken);
        Http http = new Http();

        HttpResponse resp = new HttpResponse();
        resp = http.send(request);
        // String body = '';
        String body = resp.getBody();
        System.debug(body);
        QB_UserWrapper userInfo = (QB_UserWrapper)System.JSON.deserialize(body, QB_UserWrapper.class);

        Map<String,String> attributeMap = new Map<String,String>{'noauth' => 'NOUTHS'};

        Auth.UserData userdate = new Auth.UserData(userInfo.sub, userInfo.givenName,userInfo.familyName,userInfo.givenName+' '+userInfo.familyName,userInfo.email,null,userInfo.email,'en_US','QuickBooks',null,attributeMap);

        // UserData(identifier, firstName, lastName, fullName, email, link, userName, locale, provider, siteLoginUrl, attributeMap)

        // Auth.UserData userdate = new Auth.UserData(null,null,null,null,null,null,null,null,null,null,attributeMap);

        System.debug('### userInfo '+userInfo);

        return userdate;
    }

    private String getTokenValueFromResponse(String response, String token, String ns) {
        Dom.Document docx = new Dom.Document();
        docx.load(response);
        String ret = null;

        dom.XmlNode xroot = docx.getrootelement() ;
        if(xroot != null){
           ret = xroot.getChildElement(token, ns).getText();
        }
        return ret;
    }  

    public class QB_Wrapper{
        public Integer x_refresh_token_expires_in;
        public String refresh_token;
        public String access_token;
        // public String id_token;	
        public String token_type;
        public Integer expires_in;
    }    
}

