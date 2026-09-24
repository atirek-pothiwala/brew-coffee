enum CoffeeCategoryId {
  espresso,
  cappuccino,
  latte,
  americano,
  mocha,
  coldBrew,
  icedLatte,
  macchiato,
}

enum CoffeeSize { small, medium, large }

enum MilkType { whole, oat, almond, soy, none }

enum Temperature { hot, warm, iced }

enum ExtraShot { none, one, two }

enum Flavor { none, vanilla, caramel, hazelnut, chocolate }

enum Topping { none, whippedCream, cinnamon, cocoa, caramelDrizzle }

enum PaymentMethod { demoCard, cash }

enum FulfillmentType { pickup, delivery }

enum CoffeeMachinePhase {
  idle,
  preparing,
  grindingBeans,
  brewing,
  addingMilk,
  addingFlavor,
  addingToppings,
  finalizing,
  completed,
  error,
}

enum OrderStatusStep {
  orderReceived,
  paymentConfirmed,
  preparing,
  almostReady,
  readyForPickup,
}

extension CoffeeSizeX on CoffeeSize {
  String get label => switch (this) {
        CoffeeSize.small => 'Small',
        CoffeeSize.medium => 'Medium',
        CoffeeSize.large => 'Large',
      };
}

extension MilkTypeX on MilkType {
  String get label => switch (this) {
        MilkType.whole => 'Whole Milk',
        MilkType.oat => 'Oat Milk',
        MilkType.almond => 'Almond Milk',
        MilkType.soy => 'Soy Milk',
        MilkType.none => 'No Milk',
      };
}

extension TemperatureX on Temperature {
  String get label => switch (this) {
        Temperature.hot => 'Hot',
        Temperature.warm => 'Warm',
        Temperature.iced => 'Iced',
      };
}

extension ExtraShotX on ExtraShot {
  String get label => switch (this) {
        ExtraShot.none => 'None',
        ExtraShot.one => 'One extra shot',
        ExtraShot.two => 'Two extra shots',
      };
}

extension FlavorX on Flavor {
  String get label => switch (this) {
        Flavor.none => 'None',
        Flavor.vanilla => 'Vanilla',
        Flavor.caramel => 'Caramel',
        Flavor.hazelnut => 'Hazelnut',
        Flavor.chocolate => 'Chocolate',
      };
}

extension ToppingX on Topping {
  String get label => switch (this) {
        Topping.none => 'None',
        Topping.whippedCream => 'Whipped Cream',
        Topping.cinnamon => 'Cinnamon',
        Topping.cocoa => 'Cocoa',
        Topping.caramelDrizzle => 'Caramel Drizzle',
      };
}

extension CoffeeCategoryIdX on CoffeeCategoryId {
  String get label => switch (this) {
        CoffeeCategoryId.espresso => 'Espresso',
        CoffeeCategoryId.cappuccino => 'Cappuccino',
        CoffeeCategoryId.latte => 'Latte',
        CoffeeCategoryId.americano => 'Americano',
        CoffeeCategoryId.mocha => 'Mocha',
        CoffeeCategoryId.coldBrew => 'Cold Brew',
        CoffeeCategoryId.icedLatte => 'Iced Latte',
        CoffeeCategoryId.macchiato => 'Macchiato',
      };
}

extension CoffeeMachinePhaseX on CoffeeMachinePhase {
  String get operationLabel => switch (this) {
        CoffeeMachinePhase.idle => 'Ready',
        CoffeeMachinePhase.preparing => 'Preparing machine…',
        CoffeeMachinePhase.grindingBeans => 'Grinding beans…',
        CoffeeMachinePhase.brewing => 'Brewing espresso…',
        CoffeeMachinePhase.addingMilk => 'Adding milk…',
        CoffeeMachinePhase.addingFlavor => 'Adding flavour…',
        CoffeeMachinePhase.addingToppings => 'Adding toppings…',
        CoffeeMachinePhase.finalizing => 'Finalizing…',
        CoffeeMachinePhase.completed => 'Coffee ready!',
        CoffeeMachinePhase.error => 'Something went wrong',
      };
}

extension OrderStatusStepX on OrderStatusStep {
  String get label => switch (this) {
        OrderStatusStep.orderReceived => 'ORDER RECEIVED',
        OrderStatusStep.paymentConfirmed => 'PAYMENT CONFIRMED',
        OrderStatusStep.preparing => 'GRINDING BEANS',
        OrderStatusStep.almostReady => 'BREWING COFFEE',
        OrderStatusStep.readyForPickup => 'READY FOR PICKUP',
      };
}
