@isTest
public with sharing class MailchimpSubscriberTest {
    @isTest
    static void TestMethods() {
        MailchimpSubscriber subscriber = new MailchimpSubscriber('john.doe@example.com')
            .setStatus(MailchimpSubscriber.Status.subscribed)
            .setEmailType('html')
            .addMergeField('FNAME', 'John')
            .setVIP(true)
            .setLocation(60.1733, 24.9410)
            .addTag('influencer');

           String out = subscriber.toString();

           System.assertEquals(false, out.contains('null'));
    }
}
