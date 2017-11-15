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

        // post affix
        if($('.section-nav').length) {
            var affixList = [];
            $('.section-nav li a').each(function() {
                affixList.push($(this).attr('href'));
            });
            
            $(window).on('scroll', function() {
                var scrollTop = $(window).scrollTop();

                if (scrollTop > 200 && scrollTop < $('.bottom-teaser').offset().top - $(window).height() + 300) {
                    $('.section-nav').addClass('active');
                } else {
                    $('.section-nav').removeClass('active');
                }

                for (let i = 1; i < affixList.length; i++) {
                    if(scrollTop < $(affixList[i]).offset().top - 10) {
                        var activeLi = $('.section-nav li a[href=' + affixList[i-1] + ']');
                        if (!activeLi.hasClass('active')) {
                            $('.section-nav li a').removeClass('active');
                            activeLi.addClass('active');
                        }
                        break;
                    }

                    if (i == affixList.length - 1) {
                        var activeLi = $('.section-nav li a[href=' + affixList[i] + ']');
                        if (!activeLi.hasClass('active')) {
                            $('.section-nav li a').removeClass('active');
                            activeLi.addClass('active');
                        }
                    }
                }
            });
        }
    });

}(jQuery));
