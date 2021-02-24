import 'package:after_layout/after_layout.dart';
import 'package:cable_vasool/api/models/connection_list_model.dart';
import 'package:cable_vasool/providers/common/connection_list_screen_provider.dart';
import 'package:cable_vasool/providers/operator/operator_dashboard_provider.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class ConnectionListScreen extends StatefulWidget {
  final int lineId;
  final List<LineModel> lineList;

  ConnectionListScreen({@required this.lineId, @required this.lineList});

  @override
  _ConnectionListScreenState createState() => _ConnectionListScreenState();
}

class _ConnectionListScreenState extends State<ConnectionListScreen>
    with AfterLayoutMixin, SingleTickerProviderStateMixin {
  ConnectionListScreenProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Line',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '24 October 2020',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
            label: Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Selector<ConnectionListScreenProvider, ListState>(
        selector: (_, provider) => provider.listState,
        builder: (context, state, child) {
          switch (state) {
            case ListState.loading:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ListState.loaded:
              return ConnectionListLoadedState(_provider);
              break;
            case ListState.empty:
              return Center(
                child: Text('No Connections'),
              );
              break;
            case ListState.error:
              return Center(
                child: Text('Try Again Later'),
              );
              break;
            default:
              return Center(
                child: Text('Try Again Later'),
              );
          }
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _provider =
        Provider.of<ConnectionListScreenProvider>(context, listen: false);
    _provider.lineId = widget.lineId;
    _provider.lineList = widget.lineList;
    _provider.getFirstConnectionList();
    _provider.tabController = TabController(length: 3, vsync: this);
    _provider.initializeTabController();
  }
}

class ConnectionListLoadedState extends StatelessWidget {
  final ConnectionListScreenProvider provider;

  const ConnectionListLoadedState(
    this.provider, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: provider.lineList
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Selector<ConnectionListScreenProvider, int>(
                        selector: (_, provider) => provider.lineId,
                        builder: (context, lineId, child) {
                          return ActionChip(
                            onPressed: () =>
                                provider.onSwitchChip(int.parse(e.id)),
                            label: Text(e.name),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            elevation: e.isSelected ? 4 : 0,
                            backgroundColor: e.isSelected
                                ? Colors.purple
                                : Colors.transparent,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: e.isSelected
                                        ? Colors.white
                                        : Colors.grey),
                          );
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                child: TabBar(
                  tabs: [
                    Tab(
                      text: 'Pending',
                    ),
                    Tab(
                      text: 'Disconnected',
                    ),
                    Tab(
                      text: 'Collected',
                    )
                  ],
                  controller: provider.tabController,
                  indicatorColor: Colors.white,
                ),
              ),
              Expanded(
                  child: Selector<ConnectionListScreenProvider,
                      Tuple2<List<Connection>, int>>(
                selector: (_, provider) => Tuple2<List<Connection>, int>(
                    provider.connectionList, provider.tabIndex),
                builder: (context, model, child) {
                  List<Connection> _list = [];
                  switch (model.item2) {
                    case 0:
                      _list = model.item1
                          .where((element) => element.paymentHistories.isEmpty)
                          .toList();
                      if (_list.isEmpty)
                        return Center(
                          child: Text('No Connections'),
                        );
                      break;
                    case 1:
                      _list = model.item1
                          .where((element) =>
                              element.disconnectedHistories.isNotEmpty)
                          .toList();
                      if (_list.isEmpty)
                        return Center(
                          child: Text('No Connections'),
                        );
                      break;
                    case 2:
                      _list = model.item1
                          .where(
                              (element) => element.paymentHistories.isNotEmpty)
                          .toList();
                      if (_list.isEmpty)
                        return Center(
                          child: Text('No Connections'),
                        );
                      break;
                    default:
                      return SizedBox();
                  }
                  return LazyLoadScrollView(
                    onEndOfPage: () => provider.hasMore
                        ? provider.getNextConnectionList()
                        : null,
                    isLoading: provider.listState == ListState.loading,
                    scrollDirection: Axis.vertical,
                    child: ListView.builder(
                      itemCount: _list.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        switch (model.item2) {
                          case 0:
                            Connection connection = _list[index];
                            return ConnectionItem(connection);
                          case 1:
                            Connection connection = _list[index];
                            return DisconnectedConnectionItem(connection);
                          case 2:
                            Connection connection = _list[index];
                            return CollectedConnectionItem(connection);
                          default:
                            return SizedBox();
                        }
                      },
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ],
    );
  }
}

class ConnectionItem extends StatelessWidget {
  final Connection connection;
  final _color = RandomColor();

  ConnectionItem(
    this.connection, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: connection.isClicked ? 4 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(connection.customerName),
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Text(
              connection.connectionNumber,
              style: TextStyle(color: Colors.black),
            )),
        subtitle: Text(
            '$rupeeSign ${connection.dueAmount}, Due ${DateFormat('dd').format(connection.connectionAddedDate)}'),
        trailing: TextButton(
          child: Text(
            rupeeSign,
            style: Theme.of(context).textTheme.headline5,
          ),
          onPressed: () {},
        ),
        // trailing: PopupMenuButton<int>(
        //   // child: Icon(Icons.ri),
        //   itemBuilder: (context) {
        //     return [
        //       PopupMenuItem<int>(
        //         child: Text('Collect'),
        //         value: 1,
        //       ),
        //       PopupMenuItem<int>(
        //         child: Text('Disconnect'),
        //         value: 2,
        //       ),
        //       PopupMenuItem<int>(
        //         child: Text('Edit'),
        //         value: 3,
        //       ),
        //       PopupMenuItem<int>(
        //         child: Text('Delete'),
        //         value: 4,
        //       ),
        //     ];
        //   },
        // ),
        onTap: () {
          connection.isClicked = true;
          // showModalBottomSheet(
          //     context: context,
          //     isScrollControlled: true,
          //     builder: (context) {
          //       return PaymentHistoryBottomSheet();
          //     },
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(10),
          //           topRight: Radius.circular(10),
          //         )));
        },
      ),
    );
  }

  getColor(Connection connection) {
    if (connection.disconnectedHistories.isNotEmpty) {
      return Colors.red[200];
    } else if (connection.paymentHistories.isEmpty) {
      return Colors.orange[200];
    } else {
      return Colors.green[200];
    }
  }
}

class PendingConnectionItem extends StatelessWidget {
  final Connection connection;

  const PendingConnectionItem(
    this.connection, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(connection.customerName),
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Text(
              connection.connectionNumber,
              style: TextStyle(color: Colors.black),
            )),
        subtitle: Text(
            '$rupeeSign ${connection.dueAmount}, Due ${DateFormat('dd').format(connection.connectionAddedDate)}'),
        trailing: PopupMenuButton<int>(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                child: Text('Collect'),
                value: 1,
              ),
              PopupMenuItem<int>(
                child: Text('Disconnect'),
                value: 2,
              ),
              PopupMenuItem<int>(
                child: Text('Edit'),
                value: 3,
              ),
              PopupMenuItem<int>(
                child: Text('Delete'),
                value: 4,
              ),
            ];
          },
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return PaymentHistoryBottomSheet();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )));
        },
      ),
    );
  }
}

class DisconnectedConnectionItem extends StatelessWidget {
  final Connection connection;

  const DisconnectedConnectionItem(
    this.connection, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(connection.customerName),
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Text(
              connection.connectionNumber,
              style: TextStyle(color: Colors.black),
            )),
        subtitle: Text(
            '$rupeeSign ${connection.dueAmount}, Disconnected on 21 Oct 2020'),
        trailing: PopupMenuButton<int>(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                child: Text('Collect'),
                value: 1,
              ),
              PopupMenuItem<int>(
                child: Text('Disconnect'),
                value: 2,
                enabled: false,
              ),
              PopupMenuItem<int>(
                child: Text('Edit'),
                value: 3,
              ),
              PopupMenuItem<int>(
                child: Text('Delete'),
                value: 4,
              ),
            ];
          },
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return PaymentHistoryBottomSheet();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )));
        },
      ),
    );
  }
}

class CollectedConnectionItem extends StatelessWidget {
  final Connection connection;

  const CollectedConnectionItem(
    this.connection, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(connection.customerName),
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Text(
              connection.connectionNumber,
              style: TextStyle(color: Colors.black),
            )),
        subtitle: Text(
            '$rupeeSign ${connection.dueAmount}, Collected on 21 Oct 2020'),
        trailing: PopupMenuButton<int>(
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                child: Text('Collect'),
                value: 1,
                enabled: false,
              ),
              PopupMenuItem<int>(
                child: Text('Disconnect'),
                value: 2,
                enabled: false,
              ),
              PopupMenuItem<int>(
                child: Text('Edit'),
                value: 3,
              ),
              PopupMenuItem<int>(
                child: Text('Delete'),
                value: 4,
              ),
              PopupMenuItem<int>(
                child: Text('Undo'),
                value: 5,
              ),
            ];
          },
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return PaymentHistoryBottomSheet();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )));
        },
      ),
    );
  }
}

class PaymentHistoryBottomSheet extends StatelessWidget {
  const PaymentHistoryBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Payment History',
              style: Theme.of(context).textTheme.headline6,
            ),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text('Customer Name'),
                leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 25,
                    child: Text(
                      'A 145',
                      style: TextStyle(color: Colors.black),
                    )),
                subtitle: Text('$rupeeSign 150, Collected on 21 Oct 2020'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) => Card(
                    child: ListTile(
                  title: Text('$rupeeSign 150'),
                  subtitle: Text('17 September 2020'),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    initialValue: '150',
                    decoration:
                        InputDecoration(hintText: 'Enter Collection Amount'),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('COLLECT'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
