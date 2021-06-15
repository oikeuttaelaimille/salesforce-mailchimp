global class MailchimpAPI {

    private final String API_KEY;
    private final String SERVER;

    public MailchimpAPI(String apiKey, String server) {
        API_KEY = apiKey;
        SERVER = server;
    }

    public static String getSubscriberHash(String email) {
        String requestInput = email;

        Blob requestBlob = Blob.valueOf(requestInput);
        Blob hash = Crypto.generateDigest('MD5', requestBlob);

        return EncodingUtil.convertToHex(hash);
    }

}
