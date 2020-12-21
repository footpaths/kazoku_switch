import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final Widget title;
  final String okButtonLabel;
  final String clearButtonLabel;
  final String cancelButtonLabel;
  final TextStyle labelStyle;
  final ShapeBorder dialogShapeBorder;
  final Color checkBoxCheckColor;
  final Color checkBoxActiveColor;

  MultiSelectDialog(
      {Key key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.okButtonLabel,
      this.clearButtonLabel,
      this.cancelButtonLabel,
      this.labelStyle = const TextStyle(),
      this.dialogShapeBorder,
      this.checkBoxActiveColor,
      this.checkBoxCheckColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = List<V>();
  final _selectedValuesCurrent = List<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(()  {
      if (checked) {
        _selectedValues.add(itemValue);
        _selectedValuesCurrent.add(itemValue);

      } else {
        _selectedValues.remove(itemValue);
        _selectedValuesCurrent.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  Future<void> _onSubmitTap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saveSelect", _selectedValuesCurrent.toString());

    Navigator.pop(context, _selectedValues);


  }

  void _onClearTap() {
    setState(() {
      _selectedValues.clear();
    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      shape: widget.dialogShapeBorder,
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.cancelButtonLabel),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text(widget.clearButtonLabel),
          onPressed: _onClearTap,
        ),
        FlatButton(
          child: Text(widget.okButtonLabel),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      checkColor: widget.checkBoxCheckColor,
      activeColor: widget.checkBoxActiveColor,
      title: Text(
        item.label,
        style: widget.labelStyle,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
