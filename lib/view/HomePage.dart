import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/model/CounterModel.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/Counter.dart';
import 'package:kazoku_switch/view/ListStudent.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';



class HomePage extends StatefulWidget {
  final Presenter presenter;

  HomePage(this.presenter, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> implements Counter {

  CounterModel _viewModel;

  @override
  void initState() {
    super.initState();
    this.widget.presenter.counterView = this;
  }

  @override
  void refreshCounter(CounterModel viewModel) {
    setState(() {
      this._viewModel = viewModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: GridView.count(
          crossAxisCount: 2,
          physics: ScrollPhysics(),
          children: [
            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterStudent()));
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Ghi Danh",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center, ),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(12.0),
            ),
            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.red],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: (){
                    print('hihihihi');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListStudent()));
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Danh sách",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center,),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(8.0),
            ),

            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: (){
                    print('hihihihi');
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Đồng bộ dữ liệu",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center, ),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(8.0),
            ),
            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.red],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: (){
                    print('hihihihi');
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Bài tập",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center,),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(8.0),
            ),
            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, Colors.blue],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: (){
                    print('hihihihi');
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Quản lý",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center, ),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(8.0),
            ),
            Container( decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.red],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.5, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp
              ),
            ),
              child: Card(
                child: InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  splashColor: Colors.green,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Đăng xuất",style: new TextStyle(fontSize: 17.0, color: Colors.white), textAlign: TextAlign.center,),
                      ],
                    ),

                  ),
                ),

                color: Colors.blue,

              ),
              margin: EdgeInsets.all(8.0),
            ),
          ],
        ),

        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 10.0),
      )
    );
  }
}