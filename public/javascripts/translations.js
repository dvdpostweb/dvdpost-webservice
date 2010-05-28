$(function() {
  locale_id = window.location.pathname.match(/\/locales\/(\d*)\/translations/)[1];
  $('.edit').each(function(){
    url = '/locales/'+locale_id+'/translations/'+$(this).attr('id');
    $(this).editable(url, {
      method    : 'PUT',
      name      : 'translation[text]',
      indicator : 'Saving...',
      tooltip   : 'Click to edit...',
      cancel    : 'cancel',
      submit    : 'OK'
    });    
  });
});
