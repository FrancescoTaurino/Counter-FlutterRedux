import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Azioni possibili
enum Action {
  Increment
}

// Classe immutabile per lo stato
@immutable
class AppState {
  final int counter;

  AppState(this.counter);
}

AppState reducer(AppState prevState, dynamic action) {
  switch (action) {
    case Action.Increment:
      return AppState(prevState.counter + 1);
      break;
    default:
      debugPrint("Unknown action: " + action.toString());
      return prevState;
  }
}

main() => runApp(FlutterAppRedux1());

// Version 2 (dark): Usa StoreBuilder
class FlutterAppRedux2 extends StatelessWidget {
  final store = Store<AppState>(reducer, initialState: AppState(0));

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: this.store,
      child: StoreBuilder(
        builder: (context, Store<AppState> store) {
          return MaterialApp(
            title: "Flutter App Redux",
            theme: ThemeData.dark(),
            home: Scaffold(
              appBar: AppBar(
                title: Text("Flutter App Redux 2"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("You have pushed the button this many times:"),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      "${this.store.state.counter}",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 40.0,
                          fontStyle: FontStyle.italic
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => this.store.dispatch(Action.Increment),
                child: Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Version 1 (light): Usa StoreConnector
class FlutterAppRedux1 extends StatelessWidget {
  final store = Store<AppState>(reducer, initialState: AppState(0));

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: this.store,
      child: MaterialApp(
        title: "Flutter App Redux",
        theme: ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Flutter App Redux 1"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("You have pushed the button this many times:"),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                StoreConnector<AppState, String>(
                  converter: (store) => store.state.counter.toString(),
                  builder: (context, counter) {
                    return Text(
                      counter,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 40.0,
                          fontStyle: FontStyle.italic
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: StoreConnector<AppState, VoidCallback>(
            converter: (store) => () => store.dispatch(Action.Increment),
            builder: (context, callback) {
              return FloatingActionButton(
                onPressed: callback,
                child: Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}