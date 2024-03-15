import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isoftronix/Model/operations.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';

enum Operations{
  read , delete , update , create
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Operations currentOperation = Operations.read;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.blueGrey.shade50,
        title: Text('Task : CURD Operations',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
      child: Column(
        children: [
         Expanded(
           flex: 2,
             child: Container(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: List.generate(4, (index) =>
                     Material(
                       child: InkWell(
                         onTap: (){
                           setState(() {
                             currentOperation = Model().crudList[index].operation;
                           });
                           if(index==0){
                             showDialog(context: context, builder: (context)=> AlertDialog(
                                   content: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text('Product Name'),
                                       TextField(controller: nameController,),
                                       SizedBox(height: 20,),
                                       Text('Product Price'),
                                       TextField(controller: priceController,),
                                       SizedBox(height: 20,),
                                       InkWell(
                                         onTap: (){
                                           if(nameController.text!='' && priceController.text!='')
                                           Model.createProduct(productName: nameController.text.trim(), price: int.parse(priceController.text.trim()));
                                           else{
                                              Toast.show('Fill data' , backgroundColor: Colors.red , duration: 2);
                                           }
                                         },
                                         child: Container(
                                           color: Colors.green,
                                           child: Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text('ADD'
                                             ),
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 ));
                           }
                         },
                         child: Container(
                           width: 200,
                           height: 60,
                           color: (index==0)?  Colors.green: (currentOperation == Model().crudList[index].operation) ? Colors.red : Colors.black,
                           child: Center(
                             child: Text(Model().crudList[index].title,
                               style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),),
                           ),

                         ),
                       ),
                     ),
                 )
               ),
         )),
         Expanded(
              flex: 8,
              child: Container(
                child: StreamBuilder(
                  stream: Model.readProduct(),
                  builder:(context , snapshot){
                    if(snapshot.hasData==true){
                     return  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0 , vertical: 10),
                            child: Material(
                              color: Colors.white,
                              elevation: 10,
                              child: SizedBox(
                                height: 100,
                                child:Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]['ProductName'],
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              snapshot.data!.docs[index]['ProductPrice'].toString(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          (currentOperation== Operations.update) ? UpdateButton(context, snapshot, index) : SizedBox(),
                                          (currentOperation== Operations.delete)? DeleteButton(snapshot: snapshot,index: index):SizedBox()
                                        ],
                                      ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    );
                    }
                    else return  ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) =>
                          Shimmer(
                            child: Container(
                              color: Colors.grey.withOpacity(0.2),
                              height: 100,
                              child: Text('Loading...'),
                            ),
                          ),
                    );
                  }
                ),
              ))
        ],
      ),
      ) ,

    );
  }

  Expanded UpdateButton(BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, int index) {
    nameController.text= snapshot.data!.docs[index]['ProductName'];
    priceController.text= snapshot.data!.docs[index]['ProductPrice'].toString();
                                      return Expanded(child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: (){
                                              showDialog(context: context,
                                                  builder: (context)=> AlertDialog(
                                                  content: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text('Product Name'),
                                                      TextField(controller: nameController,),
                                                      SizedBox(height: 20,),
                                                      Text('Product Price'),
                                                      TextField(controller: priceController,),
                                                      SizedBox(height: 20,),
                                                      InkWell(
                                                        onTap: (){
                                                           Model.updateProduct(
                                                               id: snapshot.data!.docs[index].id,
                                                               name: nameController.text.toString(),
                                                               price: int.parse(priceController.text));
                                                           Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          color: Colors.green,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text('UPDATE'),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                              ),
                                              );
                                            },
                                            child: Container(
                                               height: double.maxFinite,
                                               color: Colors.green ,
                                               child: Center(child: Text('UPDATE',style: TextStyle(fontWeight: FontWeight.bold),)),
                                             ),
                                          ),
                                        ));
  }
}

class DeleteButton extends StatelessWidget {
  var snapshot ;int index;
   DeleteButton({
    super.key, required this.snapshot ,required this.index

  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: (){
          Model.deleteProduct(id: snapshot.data!.docs[index].id);
        },
        child: Container(
          height: double.maxFinite,
          color: Colors.green ,
          child: Center(child: Text('DELETE',style: TextStyle(fontWeight: FontWeight.bold))),
        ),
      ),
    ));
  }
}
