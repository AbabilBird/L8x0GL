'use strict';
'require view';
'require rpc';

var callLogs = rpc.declare({ object: 'l8x0gl', method: 'logs', expect: { '': {} } });

return view.extend({
	load: function() { return callLogs(); },
	render: function(data) {
		return E('div', {}, [
			E('h2', {}, _('L8x0GL Logs')),
			E('pre', { 'style': 'white-space: pre-wrap;' }, data.log || _('No logs found'))
		]);
	}
});
