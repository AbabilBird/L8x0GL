'use strict';
'require view';
'require rpc';
'require ui';

var callEsim = rpc.declare({ object: 'l8x0gl', method: 'esim', params: [ 'action', 'arg1', 'arg2', 'arg3' ], expect: { '': {} } });

return view.extend({
	render: function() {
		var out = E('pre', { 'style': 'white-space: pre-wrap; min-height: 12em;' }, _('No output yet'));
		function run(action, a1, a2, a3) {
			out.textContent = _('Running...');
			return callEsim(action, a1 || '', a2 || '', a3 || '').then(function(r) { out.textContent = r.output || JSON.stringify(r); });
		}
		var code = E('input', { 'class': 'cbi-input-text', 'placeholder': _('Activation code or profile ICCID') });
		return E('div', {}, [
			E('h2', {}, _('L8x0GL eSIM')),
			E('p', {}, _('Chip info, profile list, download and delete are intended to run without disconnecting the internet. Enable/switch may trigger a short reconnect only if needed.')),
			E('div', { 'class': 'cbi-page-actions' }, [
				E('button', { 'class': 'btn cbi-button cbi-button-action', 'click': function() { run('chip-info'); } }, _('Chip info')),
				' ',
				E('button', { 'class': 'btn cbi-button cbi-button-action', 'click': function() { run('profile-list'); } }, _('Profile list'))
			]),
			E('hr'),
			E('div', {}, [ code ]),
			E('div', { 'class': 'cbi-page-actions' }, [
				E('button', { 'class': 'btn cbi-button cbi-button-apply', 'click': function() { run('download', code.value); } }, _('Download profile')),
				' ',
				E('button', { 'class': 'btn cbi-button cbi-button-remove', 'click': function() { if (confirm(_('Delete selected profile?'))) run('delete', code.value); } }, _('Delete profile')),
				' ',
				E('button', { 'class': 'btn cbi-button cbi-button-apply', 'click': function() { run('enable', code.value); } }, _('Enable/Switch profile')),
				' ',
				E('button', { 'class': 'btn cbi-button cbi-button-reset', 'click': function() { run('disable', code.value); } }, _('Disable profile'))
			]),
			out
		]);
	}
});
