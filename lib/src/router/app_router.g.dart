// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goRouterHash() => r'3bad506c1abc17c9e7fb52b7f006194ceb847613';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [goRouter].
@ProviderFor(goRouter)
const goRouterProvider = GoRouterFamily();

/// See also [goRouter].
class GoRouterFamily extends Family<GoRouter> {
  /// See also [goRouter].
  const GoRouterFamily();

  /// See also [goRouter].
  GoRouterProvider call(
    GlobalKey<NavigatorState> rootNavigatorKey,
  ) {
    return GoRouterProvider(
      rootNavigatorKey,
    );
  }

  @override
  GoRouterProvider getProviderOverride(
    covariant GoRouterProvider provider,
  ) {
    return call(
      provider.rootNavigatorKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'goRouterProvider';
}

/// See also [goRouter].
class GoRouterProvider extends AutoDisposeProvider<GoRouter> {
  /// See also [goRouter].
  GoRouterProvider(
    GlobalKey<NavigatorState> rootNavigatorKey,
  ) : this._internal(
          (ref) => goRouter(
            ref as GoRouterRef,
            rootNavigatorKey,
          ),
          from: goRouterProvider,
          name: r'goRouterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$goRouterHash,
          dependencies: GoRouterFamily._dependencies,
          allTransitiveDependencies: GoRouterFamily._allTransitiveDependencies,
          rootNavigatorKey: rootNavigatorKey,
        );

  GoRouterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.rootNavigatorKey,
  }) : super.internal();

  final GlobalKey<NavigatorState> rootNavigatorKey;

  @override
  Override overrideWith(
    GoRouter Function(GoRouterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GoRouterProvider._internal(
        (ref) => create(ref as GoRouterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        rootNavigatorKey: rootNavigatorKey,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GoRouter> createElement() {
    return _GoRouterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GoRouterProvider &&
        other.rootNavigatorKey == rootNavigatorKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, rootNavigatorKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GoRouterRef on AutoDisposeProviderRef<GoRouter> {
  /// The parameter `rootNavigatorKey` of this provider.
  GlobalKey<NavigatorState> get rootNavigatorKey;
}

class _GoRouterProviderElement extends AutoDisposeProviderElement<GoRouter>
    with GoRouterRef {
  _GoRouterProviderElement(super.provider);

  @override
  GlobalKey<NavigatorState> get rootNavigatorKey =>
      (origin as GoRouterProvider).rootNavigatorKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
