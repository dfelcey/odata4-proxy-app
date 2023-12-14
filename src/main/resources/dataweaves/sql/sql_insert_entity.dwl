%dw 2.0
output application/java
// This DataWeave generates a MySQL Insert Query from your payload and metadata
 
var remoteEntityName = attributes.entitySetName match {
	case remoteEntityName is String -> remoteEntityName
	else -> ""	
}

// Transform your payload into something like this: { myKey1: 'myValue1', myKey2: 'myValue2'}.
var valuesFromPayload = {
	keys: payload pluck $$,
	values: payload pluck "'$'"
}

var extId = vars.customerID as String


// Then use joinBy to transform your keys and values into a CSV style
var columns = ( (valuesFromPayload.keys map "`$`" ) joinBy ", ") // myKey1, myKey2
var values = (valuesFromPayload.values joinBy ", ") // 'myValue1', 'myValue2'
---
"SELECT $columns FROM Account WHERE My_Ext_Id__c = $extId"