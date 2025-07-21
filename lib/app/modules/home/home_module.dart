
import 'package:agenda/app/core/modules/agenda_module.dart';
import 'package:agenda/app/modules/home/home_page.dart';


class HomeModule extends AgendaModules{

  //HomeModule({required super.routers, required super.bindings});
  HomeModule():super(
    //bindings: [],
    routers: {
      '/home': (context) => const HomePage()
    }
  );
  
  
}