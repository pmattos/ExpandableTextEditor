2021-05-04 18:01:20.737116-0300 ExpandableTextView[6584:379219] [Snapshotting] Snapshotting a view (0x7fa97e81d200, UIKeyboardImpl) that has not been rendered at least once requires afterScreenUpdates:YES.


	
	onOpenURL: 
	
	xtextview-demo://x-callback-url/TextExpanderSettings?settingsPBindex=2&
	



2021-05-04 18:01:21.098123-0300 ExpandableTextView[6584:379219] handleGetSnippetsURL SUCCEEDED


TEXT: Hello world!
Paulo Mattos
paulo.rr.mattos@icloud.com
znam
Paulo Mattos


let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()

//.navigationTitle("TextExpander Demo")

   
        .onReceive(timer) { date in
            //text = date.description
            print("TEXT:", text)
        }
   
   
