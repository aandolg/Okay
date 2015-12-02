{* Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}<li><a href="index.php?module=ProductsAdmin">Товары</a></li>{/if}
	{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">Категории</a></li>{/if}
	<li class="active"><a href="index.php?module=BrandsAdmin">Бренды</a></li>
	{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">Свойства</a></li>{/if}
    {if in_array('special', $manager->permissions)}<li><a href="index.php?module=SpecialAdmin">Промо-изображения</a></li>{/if}
{/capture}

{if $brand->id}
{$meta_title = $brand->name scope=parent}
{else}
{$meta_title = 'Новый бренд' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}


{* On document load *}
{literal}
<script>
$(function() {

	// Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Автозаполнение мета-тегов
	meta_title_touched = true;
	meta_keywords_touched = true;
	meta_description_touched = true;
	
	if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
		meta_title_touched = false;
	if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
		meta_keywords_touched = false;
	if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
		meta_description_touched = false;
		
	$('input[name="meta_title"]').change(function() { meta_title_touched = true; });
	$('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
	$('input[textarea="meta_description"]').change(function() { meta_description_touched = true; });
	
	$('input[name="name"]').keyup(function() { set_meta(); });
	
	function set_meta()
	{
		if(!meta_title_touched)
			$('input[name="meta_title"]').val(generate_meta_title());
		if(!meta_keywords_touched)
			$('input[name="meta_keywords"]').val(generate_meta_keywords());
		if(!meta_description_touched)
			$('textarea[name="meta_description"]').val(generate_meta_description());
		if(!$('#block_translit').is(':checked'))
			$('input[name="url"]').val(generate_url());
	}
	
	function generate_meta_title()
	{
		name = $('input[name="name"]').val();
		return name;
	}

	function generate_meta_keywords()
	{
		name = $('input[name="name"]').val();
		return name;
	}

	function generate_meta_description()
	{
		name = $('input[name="name"]').val();
		return name;
	}
		
	function generate_url()
	{
		url = $('input[name="name"]').val();
		url = url.replace(/[\s]+/gi, '');
		url = translit(url);
		url = url.replace(/[^0-9a-z]+/gi, '').toLowerCase();	
		return url;
	}
	
	function translit(str)
	{
		var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")   
		var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")   
	 	var res = '';
		for(var i=0, l=str.length; i<l; i++)
		{ 
			var s = str.charAt(i), n = ru.indexOf(s); 
			if(n >= 0) { res += en[n]; } 
			else { res += s; } 
	    } 
	    return res;  
	}

});

</script>
 
{/literal}

{if $languages}{include file='include_languages.tpl'}{/if}

{if $message_success}
<!-- Системное сообщение -->
<div class="message message_success">
	<span class="text">{if $message_success=='added'}Бренд добавлен{elseif $message_success=='updated'}Бренд обновлен{else}{$message_success}{/if}</span>
	<a class="link" target="_blank" href="../{$lang_link}brands/{$brand->url}">Открыть бренд на сайте</a>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
	
	<span class="share">		
		<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/brands/{$brand->url|urlencode}&title={$brand->name|urlencode}&description={$brand->description|urlencode}&image={$config->root_url|urlencode}/files/brands/{$brand->image|urlencode}&noparse=true","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/vk_icon.png" /></a>
		<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/brands/{$brand->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/facebook_icon.png" /></a>
		<a href="#" onClick='window.open("http://twitter.com/share?text={$brand->name|urlencode}&url={$config->root_url|urlencode}/brands/{$brand->url|urlencode}&hashtags={$brand->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/twitter_icon.png" /></a>
	</span>
	
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error=='url_exists'}Бренд с таким адресом уже существует{else}{$message_error}{/if}</span>
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
</div>
<!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
	<div id="name">
		<input class="name" name=name type="text" value="{$brand->name|escape}"/> 
		<input name=id type="hidden" value="{$brand->id|escape}"/> 
        <div class="checkbox">
			<a class="yandex" data-to_yandex="1" href="javascript:;">В яндекс</a>
            &nbsp;&nbsp;&nbsp;
            <a class="yandex" data-to_yandex="0" href="javascript:;">Из яндекса</a>
		</div>
	</div> 

 		
	<!-- Левая колонка свойств товара -->
	<div id="column_left">
			
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Параметры страницы</h2>
			<ul>
                <li><label class="property" for="block_translit">Заблокировать авто генерацию ссылки</label><input type="checkbox" id="block_translit" {if $brand->id}checked=""{/if} /></li>
				<li><label class=property>Адрес</label><div class="page_url"> /brands/</div><input name="url" class="page_url" type="text" value="{$brand->url|escape}" /></li>
				<li><label class=property>Заголовок</label><input name="meta_title" class="okay_inp" type="text" value="{$brand->meta_title|escape}" /></li>
				<li><label class=property>Ключевые слова</label><input name="meta_keywords" class="okay_inp" type="text" value="{$brand->meta_keywords|escape}" /></li>
				<li><label class=property>Описание</label><textarea name="meta_description" class="okay_inp">{$brand->meta_description|escape}</textarea></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
		
 		{*
		<!-- Экспорт-->
		<div class="block">
			<h2>Экспорт товара</h2>
			<ul>
				<li><input id="exp_yad" type="checkbox" /> <label for="exp_yad">Яндекс Маркет</label> Бид <input class="okay_inp" type="" name="" value="12" /> руб.</li>
				<li><input id="exp_goog" type="checkbox" /> <label for="exp_goog">Google Base</label> </li>
			</ul>
		</div>
		<!-- Свойства товара (The End)-->
		*}
			
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Правая колонка свойств товара -->	
	<div id="column_right">
	
		<!-- Изображение категории -->	
		<div class="block layer images">
			<h2>Изображение бренда</h2>
			<input class='upload_image' name="image" type="file"/>			
			<input type="hidden" name="delete_image" value=""/>
			{if $brand->image}
			<ul>
				<li>
					<a href='#' class="delete"></a>
					<img src="{$brand->image|resize:100:100:false:$config->resized_brands_dir}" alt="" />
				</li>
			</ul>
			{/if}
		</div>
		
	</div>
	<!-- Правая колонка свойств товара (The End)--> 
	
    <div class="block layer">
		<h2>Краткое описание</h2>
		<textarea name="annotation" class="editor_small">{$brand->annotation|escape}</textarea>
	</div>
    
	<!-- Описагние бренда -->
	<div class="block layer">
		<h2>Описание</h2>
		<textarea name="description" class="editor_large">{$brand->description|escape}</textarea>
	</div>
	<!-- Описание бренда (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
	
</form>
<!-- Основная форма (The End) -->

{literal}
<script>
$(function() {
    $("a.yandex").click(function() {
		var icon = $(this);
        var id = $(this).parent().parent().find('input[name="id"]').val();
        var state = $(this).data('to_yandex');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'brand_yandex', 'id': id, 'values': {'to_yandex': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
                icon.parent().find('a.yandex.success_yandex').removeClass('success_yandex');
				icon.parent().find('a.yandex.fail_yandex').removeClass('fail_yandex');
				if (data == -1) {
                    icon.addClass('fail_yandex');
                } else if (data) {
				    icon.addClass('success_yandex');
				} else {
				    icon.removeClass('success_yandex');
				}
			},
			dataType: 'json'
		});	
		return false;	
	});
});
</script>
{/literal}