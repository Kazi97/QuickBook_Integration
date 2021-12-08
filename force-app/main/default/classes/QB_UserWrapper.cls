public class QB_UserWrapper{
    public String sub;	
	public String givenName;	
	public String familyName;	
	public String email;	
	public boolean emailVerified;
	public String phoneNumber;	
	public boolean phoneNumberVerified;
	public cls_address address;
	class cls_address {
		public String streetAddress;	
		public String locality;	
		public String region;	
		public String postalCode;	
		public String country;	
	}
}