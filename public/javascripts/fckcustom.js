// CHANGE FOR APPS HOSTED IN SUBDIRECTORY
FCKRelativePath = '';

// DON'T CHANGE THESE
FCKConfig.LinkBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.ImageBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=images&Connector='+FCKRelativePath+'/fckeditor/command';
FCKConfig.FlashBrowserURL = FCKConfig.BasePath + 'filemanager/browser/default/browser.html?Type=flash&Connector='+FCKRelativePath+'/fckeditor/command';

FCKConfig.LinkUploadURL = FCKRelativePath+'/fckeditor/upload';
FCKConfig.ImageUploadURL = FCKRelativePath+'/fckeditor/upload?Type=images';
FCKConfig.FlashUploadURL = FCKRelativePath+'/fckeditor/upload?Type=flash';
//FCKConfig.SpellerPagesServerScript = FCKRelativePath+'/fckeditor/check_spelling';
FCKConfig.AllowQueryStringDebug = false;
//FCKConfig.SpellChecker = 'SpellerPages';

// ONLY CHANGE BELOW HERE
FCKConfig.SkinPath = FCKConfig.BasePath + 'skins/silver/';

FCKConfig.ToolbarSets["Simple"] = [
	['Source','-','Templates'],
	//['Cut','Copy','Paste','PasteWord','-','Print','SpellCheck'],
	//['Undo','Redo','-','Find','Replace','-','SelectAll'],
	//'/',
	//['Bold','Italic','Underline','StrikeThrough','-','Subscript','Superscript'],
        ['Bold','Italic','Underline','StrikeThrough'],
	['OrderedList','UnorderedList','-','Outdent','Indent'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyFull'],
	['Link','Unlink'],
	'/',
	['Image','Flash','Table','Rule','Smiley'],
	['FontName','FontSize'],
	['TextColor','BGColor'],
	['-','About']
] ;
