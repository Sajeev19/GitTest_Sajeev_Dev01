@RestResource(urlMapping='/Account/*')
global class RESTAccountService1 {
    @HttpGet
    global static List<Account> getAccounts() {
        String companyName = RestContext.request.params.get('companyName');
        List<Account> accounts = [ Select ID, Name, BillingState from Account where Name = :companyName];
        return accounts;
    }
}