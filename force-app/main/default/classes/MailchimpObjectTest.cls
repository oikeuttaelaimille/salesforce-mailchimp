@isTest
public class MailchimpObjectTest {
    private static final String JSON_INPUT = '{\n' +
        '  "description" :"An appliance",\n' +
        '  "accessories" : [\n' +
        '    "powerCord",' +
        '    { "right":"door handle1", "left":"door handle2" }\n' +
        '  ],\n' +
        '  "dimensions": {\n' +
        '    "height": 5.5,\n' +
        '    "width": 3.0,\n' +
        '    "depth": 2.2\n' +
        '  },\n' +
        '  "type" : null,\n' +
        '  "inventory" : 2000,\n' +
        '  "price" : 1023.45,\n' +
        '  "isShipped" : true,\n' +
        '  "modelNumber" : "123",\n' +
        '  "tags" : [\n' +
        '    "vip",' +
        '    "influencer",' +
        '    "leader"' +
        '  ]\n' +
        '}';


    @isTest
    static void TestPrimitiveData() {
        MailchimpObject m = MailchimpObject.parse(JSON_INPUT);

        System.assertEquals('An appliance', m.getObject('description'));
        MailchimpObject a = m.get('accessories');

        System.assertEquals('powerCord', a.getIdxObject(0));
        System.assertEquals('door handle1', a.getIdx(1).getObject('right'));
        System.assertEquals('door handle2', a.getIdx(1).getObject('left'));

        MailchimpObject dim = m.get('dimensions');
        System.assertEquals(5.5, dim.getObject('height'));
        System.assertEquals(3.0, dim.getObject('width'));
        System.assertEquals(2.2, dim.getObject('depth'));

        System.assertEquals(null, m.getObject('type'));
        System.assertEquals(true, m.get('type').isNull());
        System.assertEquals(2000, m.getObject('inventory'));
        System.assertEquals(1023.45, m.getObject('price'));
        System.assertEquals(true, m.getObject('isShipped'));
        System.assertEquals('123', m.getObject('modelNumber'));
    }

    @isTest
    static void TestIteration() {
        MailchimpObject m = MailchimpObject.parse(JSON_INPUT);

        for (Object obj : m.get('tags').asList()) {
            System.assertEquals(true, obj instanceof String);
        }
    }
}
