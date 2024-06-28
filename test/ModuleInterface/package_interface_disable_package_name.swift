// RUN: %empty-directory(%t)

/// Do not print package-name for public or private interfaces
// RUN: %target-build-swift -emit-module %s -I %t \
// RUN:   -module-name Bar -package-name foopkg \
// RUN:   -enable-library-evolution -swift-version 6 \
// RUN:   -package-name barpkg \
// RUN:   -Xfrontend -disable-print-package-name-for-non-package-interface \
// RUN:   -emit-module-interface-path %t/Bar.swiftinterface \
// RUN:   -emit-private-module-interface-path %t/Bar.private.swiftinterface \
// RUN:   -emit-package-module-interface-path %t/Bar.package.swiftinterface

// RUN: %FileCheck %s --check-prefix=CHECK-PUBLIC < %t/Bar.swiftinterface
// RUN: %FileCheck %s --check-prefix=CHECK-PRIVATE < %t/Bar.private.swiftinterface
// RUN: %FileCheck %s --check-prefix=CHECK-PACKAGE < %t/Bar.package.swiftinterface

// CHECK-PUBLIC-NOT: -package-name foopkg
// CHECK-PUBLIC-NOT: -package-name barpkg
// CHECK-PRIVATE-NOT: -package-name foopkg
// CHECK-PRIVATE-NOT: -package-name barpkg
// CHECK-PACKAGE-NOT: -package-name foopkg
// CHECK-PACKAGE: -package-name barpkg

// CHECK-PUBLIC: -module-name Bar
// CHECK-PRIVATE: -module-name Bar
// CHECK-PACKAGE: -module-name Bar

// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.swiftinterface -o %t/Bar.swiftmodule -module-name Bar
// RUN: rm -rf %t/Bar.swiftmodule
// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.private.swiftinterface -o %t/Bar.swiftmodule -module-name Bar
// RUN: rm -rf %t/Bar.swiftmodule
// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.package.swiftinterface -o %t/Bar.swiftmodule -module-name Bar

// RUN: rm -rf %t/Bar.swiftmodule
// RUN: rm -rf %t/Bar.swiftinterface
// RUN: rm -rf %t/Bar.private.swiftinterface
// RUN: rm -rf %t/Bar.package.swiftinterface

/// By default, -package-name is printed in all interfaces.
// RUN: %target-build-swift -emit-module %s -I %t \
// RUN:   -module-name Bar -package-name barpkg \
// RUN:   -enable-library-evolution -swift-version 6 \
// RUN:   -emit-module-interface-path %t/Bar.swiftinterface \
// RUN:   -emit-private-module-interface-path %t/Bar.private.swiftinterface \
// RUN:   -emit-package-module-interface-path %t/Bar.package.swiftinterface

// RUN: %FileCheck %s < %t/Bar.swiftinterface
// RUN: %FileCheck %s < %t/Bar.private.swiftinterface
// RUN: %FileCheck %s < %t/Bar.package.swiftinterface

// CHECK: -package-name barpkg
// CHECK: -module-name Bar

// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.swiftinterface -o %t/Bar.swiftmodule -module-name Bar
// RUN: rm -rf %t/Bar.swiftmodule
// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.private.swiftinterface -o %t/Bar.swiftmodule -module-name Bar
// RUN: rm -rf %t/Bar.swiftmodule
// RUN: %target-swift-frontend -compile-module-from-interface %t/Bar.package.swiftinterface -o %t/Bar.swiftmodule -module-name Bar

public struct PubStruct {}
@_spi(bar) public struct SPIStruct {}
package struct PkgStruct {}
