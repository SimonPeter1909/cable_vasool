import 'package:cable_vasool/api/repository.dart';
import 'package:cable_vasool/providers/operator/operator_dashboard_provider.dart';
import 'package:cable_vasool/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../api/models/connection_list_model.dart';

class ConnectionListScreenProvider with ChangeNotifier {
  ///var
  int _currentPage = 0;

  ConnectionListModel _connectionListModel;

  List<Connection> _connectionList = [];
  List<LineModel> _lineList = [];
  TabController _tabController;

  bool _hasMore = true;

  int _lineId = 0;

  ListState _listState = ListState.loading;

  int _tabIndex = 0;

  ///getters and setters

  ConnectionListModel get connectionListModel => _connectionListModel;

  set connectionListModel(ConnectionListModel value) {
    _connectionListModel = value;
  }

  List<LineModel> get lineList => _lineList;

  set lineList(List<LineModel> value) {
    _lineList = value;
  }

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
  }

  List<Connection> get connectionList => _connectionList;

  set connectionList(List<Connection> value) {
    _connectionList = value;
  }

  int get lineId => _lineId;

  set lineId(int value) {
    _lineId = value;
  }

  ListState get listState => _listState;

  set listState(ListState value) {
    _listState = value;
  }

  TabController get tabController => _tabController;

  set tabController(TabController value) {
    _tabController = value;
  }

  int get tabIndex => _tabIndex;

  set tabIndex(int value) {
    _tabIndex = value;
  }

  bool get hasMore => _hasMore;

  set hasMore(bool value) {
    _hasMore = value;
  }

  ///methods

  getFirstConnectionList() async {
    logger.d("lineId - $lineId");
    listState = ListState.loading;
    notifyListeners();
    ConnectionListModel model = await Repository()
        .getConnectionListByLine(lineId: lineId, pageNumber: 0);
    if (model != null) {
      if (model.connections.isEmpty) {
        listState = ListState.empty;
      } else {
        connectionList = model.connections;
        if (connectionList.length % 10 != 0) {
          hasMore = false;
        }
        logger.d("connections - ${connectionList.length}");
        listState = ListState.loaded;
      }
    } else {
      listState = ListState.error;
    }
    notifyListeners();
  }

  getNextConnectionList() async {
    _currentPage = _currentPage + 1;
    ConnectionListModel model = await Repository()
        .getConnectionListByLine(lineId: lineId, pageNumber: _currentPage * 10);
    if (model != null) {
      connectionList = connectionList + model.connections;
      if (connectionList.length % 10 != 0) {
        hasMore = false;
      }
    } else {
      listState = ListState.error;
    }
    notifyListeners();
  }

  onSwitchChip(int selectedLineId) {
    lineList.forEach((element) {
      if (selectedLineId == int.parse(element.id)) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    });
    lineId = selectedLineId;
    getFirstConnectionList();
    // notifyListeners();
  }

  void initializeTabController() {
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        tabIndex = tabController.index;
        notifyListeners();
      }
    });
  }
}
