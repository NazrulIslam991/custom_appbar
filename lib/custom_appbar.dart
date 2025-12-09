import 'package:flutter/material.dart';

typedef OnSearch = void Function(String query);
typedef OnChanged = void Function(String query);
typedef OnLeadingPressed = void Function();

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData leadingIcon;
  final OnSearch? onSearch;
  final OnChanged? onChanged;
  final OnLeadingPressed? onLeadingPressed;
  final double toolbarHeight;
  final Alignment titleAlignment;
  final ShapeBorder? bottomShape;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? leadingIconColor;
  final Color? actionIconColor;
  final Color? textColor;
  final TextStyle? titleStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? hintTextStyle;
  final double leadingIconSize;
  final double actionIconSize;
  final Widget? profileAvatar;
  final List<PopupMenuEntry<dynamic>>? popupMenuItems;
  final ValueChanged<dynamic>? onProfileMenuSelected;
  final int notificationCount;
  final String hintText;
  final bool keepSearchOpenAfterSubmit;
  final IconData searchIcon;
  final IconData closeIcon;

  const CustomAppBar({
    Key? key,
    this.title = "App Title",
    this.leadingIcon = Icons.menu,
    this.onSearch,
    this.onChanged,
    this.onLeadingPressed,
    this.backgroundColor,
    this.leadingIconColor,
    this.actionIconColor,
    this.textColor,
    this.titleStyle,
    this.searchTextStyle,
    this.hintTextStyle,
    this.leadingIconSize = 24.0,
    this.actionIconSize = 24.0,
    this.toolbarHeight = kToolbarHeight,
    this.titleAlignment = Alignment.centerLeft,
    this.bottomShape,
    this.bottom,
    this.profileAvatar,
    this.popupMenuItems,
    this.onProfileMenuSelected,
    this.notificationCount = 0,
    this.hintText = "Search...",
    this.keepSearchOpenAfterSubmit = false,
    this.searchIcon = Icons.search,
    this.closeIcon = Icons.close,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    double totalHeight = toolbarHeight;
    if (bottom != null) {
      totalHeight += bottom!.preferredSize.height;
    }
    return Size.fromHeight(totalHeight);
  }
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  late AnimationController _anim;
  late Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expand = CurvedAnimation(
      parent: _anim,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _anim.forward().then((_) {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      } else {
        _controller.clear();
        widget.onChanged?.call('');
        FocusScope.of(context).unfocus();
        _anim.reverse();
      }
    });
  }

  void _submitSearch(String text) {
    final v = text.trim();
    if (v.isEmpty) return;
    widget.onSearch?.call(v);

    FocusScope.of(context).unfocus();

    if (!widget.keepSearchOpenAfterSubmit) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _toggleSearch();
      });
    }
  }

  Widget _buildSearchField() {
    final Color defaultSearchTextColor =
        widget.textColor ?? _getThemeAwareDefaultColor(context);
    final TextStyle defaultSearchTextStyle =
        TextStyle(color: defaultSearchTextColor);
    final TextStyle defaultHintStyle = defaultSearchTextStyle.copyWith(
      color: defaultSearchTextColor.withOpacity(0.7),
    );

    return FadeTransition(
      opacity: _expand,
      child: SizeTransition(
        sizeFactor: _expand,
        axisAlignment: -1.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            style: widget.searchTextStyle ?? defaultSearchTextStyle,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle ?? defaultHintStyle,
              border: InputBorder.none,
              suffixIcon: null,
            ),
            onChanged: widget.onChanged,
            onSubmitted: _submitSearch,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    final Color defaultTextColor =
        widget.textColor ?? _getThemeAwareDefaultColor(context);

    final TextStyle defaultTitleStyle = TextStyle(color: defaultTextColor);

    return Text(
      widget.title,
      style: widget.titleStyle ?? defaultTitleStyle,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildNotificationIcon(Color effectiveActionIconColor) {
    if (widget.notificationCount == 0) {
      return Icon(Icons.notifications_none,
          color: effectiveActionIconColor, size: widget.actionIconSize);
    }

    return Stack(
      children: [
        Icon(Icons.notifications_none,
            color: effectiveActionIconColor, size: widget.actionIconSize),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              widget.notificationCount > 9
                  ? '9+'
                  : widget.notificationCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildProfileButton(Color effectiveActionIconColor) {
    final bool hasAvatar = widget.profileAvatar != null;

    return IconButton(
      onPressed: () => widget.onProfileMenuSelected?.call(null),
      icon: hasAvatar
          ? widget.profileAvatar!
          : Icon(
              Icons.person,
              color: effectiveActionIconColor,
              size: widget.actionIconSize,
            ),
    );
  }

  Color _getThemeAwareDefaultColor(BuildContext context) {
    final Brightness currentBrightness = Theme.of(context).brightness;

    if (widget.backgroundColor != null) {
      return Colors.white;
    } else {
      return currentBrightness == Brightness.dark ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeAwareDefaultColor = _getThemeAwareDefaultColor(context);

    final Color effectiveLeadingIconColor =
        widget.leadingIconColor ?? themeAwareDefaultColor;
    final Color effectiveActionIconColor =
        widget.actionIconColor ?? themeAwareDefaultColor;

    final List<Widget> actionsList = [];

    actionsList.add(
      IconButton(
        onPressed: _toggleSearch,
        icon: Icon(
          _isSearching ? widget.closeIcon : widget.searchIcon,
          color: effectiveActionIconColor,
          size: widget.actionIconSize,
        ),
      ),
    );

    if (!_isSearching) {
      if (widget.notificationCount > 0) {
        actionsList.add(
          IconButton(
            onPressed: () {},
            icon: _buildNotificationIcon(effectiveActionIconColor),
          ),
        );
      }

      if (widget.profileAvatar != null ||
          widget.onProfileMenuSelected != null) {
        actionsList.add(
          _buildProfileButton(effectiveActionIconColor),
        );
      }
    }

    return AppBar(
      backgroundColor: widget.backgroundColor,
      toolbarHeight: widget.toolbarHeight,
      shape: widget.bottomShape,
      bottom: widget.bottom,
      leading: IconButton(
        onPressed:
            _isSearching ? _toggleSearch : widget.onLeadingPressed ?? () {},
        icon: Icon(
          widget.leadingIcon,
          color: effectiveLeadingIconColor,
          size: widget.leadingIconSize,
        ),
      ),
      title: Align(
        alignment: widget.titleAlignment,
        child: _isSearching ? _buildSearchField() : _buildTitleText(),
      ),
      actions: actionsList,
    );
  }
}
