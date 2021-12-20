// the controller using by SeachPage
// 
global with sharing class SearchController {
   public String key {get;set;}
   public List<SearchResult> searchResults{get;set;}
   public List<Contact> lstContact = new List<Contact>();
   public List<Account> lstAccount = new List<Account>();
    
	public List<SearchResult> getContacts() {
       String keySearch= key +'%';
       SearchResult temp;
       List<SearchResult> results = new List<SearchResult>();
        
       // the search box is blank
       if(String.isBlank(key)){
           return results;
       }
        
       // seach for Contact
       lstContact =  Database.query(
            'SELECT Name,Id ' +
            'FROM Contact '  + 
           	'WHERE Name like :keySearch ' +
            'LIMIT 10'
        );
        
        // seach for Account
        lstAccount =  Database.query(
            'SELECT Name, Id ' +
            'FROM Account ' + 'WHERE Name like :keySearch ' +
            'LIMIT 10'
        );
        
        if(lstContact != null && lstContact.size() > 0){
            // list Contact
            for(Contact contact : lstContact){
                temp = new SearchResult();
                temp.name = contact.Name;
                temp.id = contact.Id;
                temp.type = 'Contact';
                results.add(temp);
            }
    	}
        
        if(lstAccount != null && lstAccount.size() > 0){
            // list Account
            for(Account account : lstAccount){
                temp = new SearchResult();
                temp.name = account.Name;
                temp.id = account.Id;
                temp.type = 'Account';
                results.add(temp);
            }
    	}
        return results;
    }
    
    // search action
    public PageReference search_now(){
       searchResults =  getContacts();
       return null;
    }
}