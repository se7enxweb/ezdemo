{def $valid_nodes = $block.valid_nodes
     $first = $valid_nodes.0
     $big_image_class = 'gallery'
     $render_image_once = false()}
<!-- BLOCK: START -->
<div class="block-type-gallery">

    <div class="block-gallery">
        <div class="gallery-viewer">
            {node_view_gui view='gallery_viewer' big_class=$big_image_class total_items=$valid_nodes|count content_node=$first}
            {foreach $valid_nodes as $gallery_item offset 1}
                {if eq( $gallery_item.class_identifier, 'video' )}
                    {node_view_gui view='gallery_viewer' is_hidden=true() big_class=$big_image_class total_items=$valid_nodes|count content_node=$gallery_item}
                {/if}
                {if and( eq( $gallery_item.class_identifier, 'image' ), $render_image_once|not() )}
                    {node_view_gui view='gallery_viewer' is_hidden=true() big_class=$big_image_class total_items=$valid_nodes|count content_node=$gallery_item}
                    {set $render_image_once = true()}
                {/if}
            {/foreach}
        </div>
        <div class="gallery-navigator">
            <a href="#" class="navig prev" style="opacity:0;"><span class="hide">&lt;</span></a>
            <a href="#" class="navig next"><span class="hide">&gt;</span></a>

            <img src={'fg-selected.png'|ezimage} alt="Selected indicator" class="cursor" />
            <ul class="images">
            {foreach $valid_nodes as $gallery_item}
                <li>{node_view_gui view='gallery_item' thumb_class='gallerythumbnail' big_class=$big_image_class content_node=$gallery_item}</li>
            {/foreach}
            </ul>
        </div>

    </div>
    {run-once}
    <script type="text/javascript">
    {literal}

    jQuery(function ($) {
        $('.block-type-gallery').each(function () {
            var g = new $.eZ.Gallery({
                title: 'h3 a',
                caption: 'figcaption div',
                autoFixSizes: false,
                autoScrollOnSelect: false,
                navigator: {
                    gallery: $(this).find('.block-gallery')
                },
                initFunc: function () {
                    var imgs = this.navigator.getImages();

                    // make the browser caches images
                    setTimeout(function () {
                        imgs.each(function (i, elem) {
                            (new Image).src = elem.getAttribute('data-gallery-src');
                        });
                    }, 0);
                },
                updateFunc: function (item) {
                    var node = item.imageNode,
                        viewerImage = this.container.find('.gallery-viewer-image').first(),
                        img = viewerImage.children('img').first();

                    if ( node.attr('data-gallery-item') == 'image' ) {
                        this.container.find('.visible').first().removeClass('visible').addClass('hidden');
                        viewerImage.removeClass('hidden').addClass('visible');
                    } else if ( node.attr('data-gallery-item') == 'video' ) {
                        viewerImage.removeClass('visible').addClass('hidden');
                        this.container.find('#gallery-viewer-video-' + node.attr('data-gallery-node-id')).first().removeClass('hidden').addClass('visible');
                    }

                    if ( img.length ) {
                        img.attr('src', node.attr('data-gallery-src'));
                        img.attr('height', node.attr('data-gallery-height'));
                        img.attr('width', node.attr('data-gallery-width'));
                        img.attr('alt', node.prop('title'));
                    }

                    var t = this.container.find('.visible ' + this.conf.title).first(),
                        cap = this.container.find('.visible ' + this.conf.caption).first(),
                        c = this.container.find('.visible ' + this.conf.counter).first();

                    t.text(node.prop('title'));
                    t.attr('href', node.attr('data-gallery-node-url'));
                    c.text(item.index + 1);
                    cap.html(node.find('figcaption').html());
                }
            });
        });
    });
    {/literal}
    </script>
    {/run-once}
{undef $valid_nodes $first $big_image_class $render_image_once}
</div>
<!-- BLOCK: END -->
