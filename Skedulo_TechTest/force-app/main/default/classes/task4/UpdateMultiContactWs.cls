// The Resful web serice uses to update multiple contacts
// 
@RestResource(urlMapping='/UpdateMultiContactWs/*')
global with sharing class UpdateMultiContactWs {
    static final String SUCCESS = 'Success';
    static final String FAIL = 'Fail';
    static final String INAVLIDCONTACT = 'Invalid contract';
    
    @HttpPatch
    global static List<UpdateContactResponse> updateAccount() {
        RestRequest req = RestContext.request;
        List<UpdateContactResponse> lstResponse = new List<UpdateContactResponse>();
         
       	Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.tostring());
 		// get the contacts object from the JSON request
        List<Object> contacts = (List<Object>)params.get('contacts'); 
  
        if(contacts != null && contacts.size() > 0){
            for(Object contact : contacts){
                UpdateContactResponse resItem = new UpdateContactResponse();
                Map<String, Object> item = (Map<String, Object>)contact;
                String id = item.get('Id').toString();
                Contact[] contactInSystem = [SELECT Id, Name FROM Contact WHERE Id = :id];
                
                // check whether the contact exist or not
                if(contactInSystem.size() > 0){
                    // contact existed
                    try{
                        Contact ctToUpdate = new Contact();
                        for(String fieldName : item.keySet()){
                            ctToUpdate.put(fieldName, item.get(fieldName));
                        }
                        // update contact
                        update ctToUpdate;
                        resItem.status = SUCCESS;
                        resItem.contactId = id;
                    } catch (Exception e){
                        // Exception
                        resItem.status = FAIL;
                        resItem.contactId = id;
                        resItem.errorDescription = e.getMessage();
                    }
                } else {
                    // contact does not exist
                    resItem.status = FAIL;
                    resItem.contactId = id;
                    resItem.errorDescription = INAVLIDCONTACT;
                }
                lstResponse.add(resItem);
            }
		}
        return lstResponse;
    }
    
    // Response structure
    global with sharing class UpdateContactResponse {
        String status{get; set;}
        String errorDescription{get; set;}
        String contactId{get; set;}
        Contact contact{get; set;}
        
        public UpdateContactResponse(){
            contact = new Contact();
        }
    }
}