@RestResource(urlMapping='/sendfile/*')
global with sharing class RestClass {

    @HttpGet
    global static void sendFile() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        // Retrieve the ContentVersion record Id from the request body or URL parameter
        // String contentVersionId = request.params.get('contentVersionId');
        
        // Retrieve the ContentVersion record
        ContentVersion contentVersion = [SELECT Id, Title, VersionData FROM ContentVersion LIMIT 1];
        
        // Set the necessary headers for the response
        response.addHeader('Content-Disposition', 'attachment; filename="' + contentVersion.Title + '"');
        response.addHeader('Content-Type', 'application/octet-stream');
        
        // Send the file data in the response body
        response.responseBody = contentVersion.VersionData;
    }
}