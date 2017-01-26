/**
 * Main JS file for Casper behaviours
 */

/*globals jQuery, document */
(function ($) {
    "use strict";

    $(document).ready(function(){

        $(".post-content").fitVids();

        // Calculates Reading Time
        var txt = $('<div></div>').hide().text($('.post-content p, .post-content li').text()).appendTo($('body'));
        txt.readingTime({
            readingTimeTarget: '.post-reading-time',
            wordCountTarget: '.post-word-count',
            wordsPerMinute: 200,
        });

        // Creates Captions from Alt tags
        $(".post-content img").each(function() {
            // Let's put a caption if there is one
            if($(this).attr("alt") && !$(this).hasClass("emoji"))
              $(this).wrap('<figure class="image"></figure>')
              .after('<figcaption>'+$(this).attr("alt")+'</figcaption>');
        });

        // waiting
        $('.waiting-post').click(function() {
            if(confirm('작성중인 글입니다. 이메일 구독을 신청하시겠습니까? 새로운 글이 올라오면 알려드려요!')) {
                location.href = _mailChimpUrl;
            }
        });
    });

}(jQuery));
