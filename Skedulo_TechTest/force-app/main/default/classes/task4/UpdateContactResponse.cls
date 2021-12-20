global with sharing class UpdateContactResponse {
	String status{get; set;}
        String errorDescription{get; set;}
        String contactId{get; set;}
        Contact contact{get; set;}
        
        public UpdateContactResponse(){
            contact = new Contact();
        }
}