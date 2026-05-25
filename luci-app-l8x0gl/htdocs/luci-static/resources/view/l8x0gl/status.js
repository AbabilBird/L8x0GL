'use strict';
'require view';
'require rpc';
'require ui';

var callStatus = rpc.declare({ object: 'l8x0gl', method: 'status', expect: { '': {} } });
var callAction = rpc.declare({ object: 'l8x0gl', method: 'action', params: [ 'name' ], expect: { '': {} } });

return view.extend({
	load: function() { return callStatus(); },
	render: function(data) {
		var rows = [
			[ _('Enabled'), data.enabled || '-' ],
			[ _('Interface'), data.interface || '-' ],
			[ _('Mode'), data.mode || '-' ],
			[ _('MBIM device'), data.mbim_device || '-' ],
			[ _('Data interface'), data.data_interface || '-' ],
			[ _('AT port'), data.at_port || '-' ],
			[ _('IPv4'), data.ipv4 || '-' ],
			[ _('Default route'), data.default_route || '-' ],
			[ _('mbim-proxy PID'), data.mbim_proxy_pid || '-' ],
			[ _('lpac-mbim available'), data.lpac_mibm_available || '-' ]
		];
		var table = E('table', { 'class': 'table' }, rows.map(function(r) { return E('tr', {}, [ E('td', {}, r[0]), E('td', {}, r[1]) ]); }));
		var buttons = E('div', { 'class': 'cbi-page-actions' }, [
			E('button', { 'class': 'btn cbi-button cbi-button-action', 'click': ui.createHandlerFn(this, function() { return callAction('detect').then(function(r) { ui.addNotification(null, E('p', {}, r.output || _('Detect done'))); location.reload(); }); }) }, _('Detect')),
			' ',
			E('button', { 'class': 'btn cbi-button cbi-button-apply', 'click': ui.createHandlerFn(this, function() { return callAction('setup-network').then(function(r) { ui.addNotification(null, E('p', {}, r.output || _('Network configured'))); }); }) }, _('Setup network')),
			' ',
			E('button', { 'class': 'btn cbi-button cbi-button-apply', 'click': ui.createHandlerFn(this, function() { return callAction('connect').then(function() { location.reload(); }); }) }, _('Connect')),
			' ',
			E('button', { 'class': 'btn cbi-button cbi-button-reset', 'click': ui.createHandlerFn(this, function() { return callAction('disconnect').then(function() { location.reload(); }); }) }, _('Disconnect')),
			' ',
			E('button', { 'class': 'btn cbi-button cbi-button-reload', 'click': ui.createHandlerFn(this, function() { return callAction('reconnect').then(function() { location.reload(); }); }) }, _('Reconnect'))
		]);
		return E('div', {}, [ E('h2', {}, _('L8x0GL MBIM Status')), table, buttons ]);
	}
});
