import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_ml_example/features/home/controller/home_controller.dart';
import 'package:google_ml_example/features/home/view/sound_play.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = HomeController();



  // @override
  // void initState() {    
  //   super.initState();
  //   _homeController.loadCamera();
  //   _homeController.startImageStream();
  // }

  @override
  void dispose() {    
    super.dispose();
    _homeController.dispose();

  }

  var mood = "Not Real face detected";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          backgroundColor:  Colors.red,
          onPressed: () {
            if(mood == "Not Real face detected"){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Not Real face detected".toUpperCase()),
                duration: Duration(milliseconds: 300),
              ));
            }else
            Navigator.push(context, MaterialPageRoute(builder: (_)=> AudioPlayer(mood)));
          },
          // child: Icon(Icons.camera_alt),
        ),
      ),
      body: GetBuilder<HomeController>(
        init: _homeController,
        initState: (_) async {
          await _homeController.loadCamera();
          _homeController.startImageStream();
        },
        dispose: (_)async{
          _.dispose();
          _.controller!.dispose();
          _homeController.dispose();
        },
        builder: (_) {

          
          mood = _.label!;


          return Container(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.20,
                  width: size.width,
                  color: Colors.yellow,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MOOD: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${_.label!.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LIVENESS: ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          checkLivness(_.faces),
                        ],
                      ),
                      checkRealandFake(_.faces,_.label),
                      SizedBox(
                        height: 20,
                      ),                      
                    ],
                  ),
                ),
                _.cameraController != null &&
                        _.cameraController!.value.isInitialized
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: CameraPreview(_.cameraController!))
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        ))),

                // Expanded(
                //   child: Container(
                //     alignment: Alignment.topCenter,
                //     width: 200,
                //     height: 200,
                //     color: Colors.white,
                //     child: Image.asset(
                //       'images/${_.faceAtMoment}',
                //       fit: BoxFit.fill,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }

      var list1 = [];
      var list2 = [];
      var diffReal = [];
      var diffFake = [];
      // var livnessPic = "FAKE  ";


  checkRealandFake(faces,label){
         var livnessPic ="";

    if((faces == null && faces!.isEmpty) || (label == 'Not Real face detected' )){
          list1.clear();
          list2.clear();
          diffReal.clear();
          diffFake.clear();
        }
   else if (faces != null && faces!.isNotEmpty) {
      var liveness = (faces?.first.smile*100).round();
      // Future.delayed(Duration(seconds: 20),(){
        if(list1.length <= 5){
          list1.add(liveness);
        }
       else{
         if(list2.length <= 5)
          list2.add(liveness);
        }
        

        if(list1.length == 6 && list2.length == 6 )
        for (var i = 0; i <= 5; i++) {
         var diff =  list1[i] - list2[i];
         if(diff<0){
          diff = diff * -1;
         }
         if(diff > 2){
           diffReal.add(diff);
          //  livnessPic = "REAL$diff";
         }else{
           diffFake.add(diff);
          //  livnessPic = "FAKE$diff";
         }

        }
         if(diffReal.length < diffFake.length){
           if(list1.length == 6 && list2.length == 6){

               list1.clear();
           list2.clear();
           diffReal.clear();
           diffFake.clear();
           }
           livnessPic = "FAKE";
          //  return Text("REAL");
          //  setState(() {
          //  });
         }else{
            if(list1.length == 6 && list2.length == 6){

               list1.clear();
           list2.clear();
           diffReal.clear();
           diffFake.clear();
           }
           livnessPic = "REAL";

            // return Text("FAKE");
         }

    

    }

    return Text(livnessPic);
  }

  checkLivness(faces) {
       
    if (faces != null && faces!.isNotEmpty) {
      var liveness = (faces?.first.smile*100).round();
     
    return  Text(
        ' $liveness',
        style: TextStyle(
          fontSize: 18,
        ),
      );
    } else {
     return Text(
        '0',
        style: TextStyle(
          fontSize: 18,
        ),
      );
    }
  }
}
