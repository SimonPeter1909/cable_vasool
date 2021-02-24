import 'package:after_layout/after_layout.dart';
import 'package:cable_vasool/api/models/dashboard_model.dart';
import 'package:cable_vasool/providers/common/connection_list_screen_provider.dart';
import 'package:cable_vasool/providers/operator/operator_dashboard_provider.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:cable_vasool/views/common/connections_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OperatorDashboard extends StatefulWidget {
  @override
  _OperatorDashboardState createState() => _OperatorDashboardState();
}

class _OperatorDashboardState extends State<OperatorDashboard>
    with AfterLayoutMixin {
  OperatorDashboardProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<OperatorDashboardProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, Anbu'),
        titleSpacing: 0,
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
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Anbu'),
              accountEmail: Text('fsdaf@fasd.casd'),
            ),
            ListTile(
              title: Text('Add New Connection'),
              trailing: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
      body: Consumer<OperatorDashboardProvider>(
        builder: (context, provider, child) {
          switch (provider.state) {
            case DashboardState.loading:
              return Center(
                child: Text('Loading'),
              );
              break;
            case DashboardState.loaded:
              return DashboardLoadedState(provider);
              break;
            case DashboardState.error:
              return Center(
                child: Text('Error'),
              );
              break;
            default:
              return Center(
                child: Text('Error'),
              );
          }
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    provider.getDashboard(today: DateTime.now());
  }
}

class DashboardLoadedState extends StatefulWidget {
  final OperatorDashboardProvider provider;

  DashboardLoadedState(this.provider);

  @override
  _DashboardLoadedStateState createState() => _DashboardLoadedStateState();
}

class _DashboardLoadedStateState extends State<DashboardLoadedState> {
  @override
  Widget build(BuildContext context) {
    final DashboardModel model = widget.provider.model;
    final List<LineModel> _lineList = widget.provider.lineList;
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Due',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            '$rupeeSign ${model.paymentCollected.aggregate.sum.amountCollected}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            ' / ',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '$rupeeSign ${model.totalConnections.aggregate.sum.dueAmount}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Connections',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            '${model.totalConnections.aggregate.count - model.connectionsCollected.aggregate.count}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            ' / ',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '${model.totalConnections.aggregate.count}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Active Setup Boxes',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            '${model.activeSetupBox.aggregate.count}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            ' / ',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '${model.totalSetupBox.aggregate.count}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Collection',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            '$rupeeSign ${model.todayPaymentCollected.aggregate.sum.amountCollected}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            ' of ',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '${model.todayConnectionsCollected.aggregate.count} Connections',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Lines',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            physics: ScrollPhysics(),
            itemCount: _lineList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // DashboardModelLine line = model.lines[index];
              LineModel _line = _lineList[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: () async {
                    _line.isSelected = true;
                    await AppNavigator(context).push(
                        child: ChangeNotifierProvider<
                            ConnectionListScreenProvider>(
                      create: (context) => ConnectionListScreenProvider(),
                      builder: (context, child) => ConnectionListScreen(
                          lineId: int.parse(_line.id), lineList: _lineList),
                    ));
                    _lineList.forEach((element) {
                      element.isSelected = false;
                    });
                  },
                  isThreeLine: true,
                  title: Text(_line.name),
                  subtitle: Text(
                      'Connections - ${_line.totalConnectionsCollected} of ${_line.totalConnections}\nAmount - ${_line.totalAmountCollected} of ${_line.totalDueAmount}'),
                  trailing: Icon(Icons.chevron_right),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
