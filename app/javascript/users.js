// 検索結果一覧
// $(document).on("turbolinks:load", function() {
//   $('.user-cards').infiniteScroll({
//     append : '.user-cards .card-index',
//     history: false,
//     button: '.loadmore-btn',
//     scrollThreshold: false,
//     path : 'nav ul.pagination a[rel=next]',
//     hideNav: 'nav ul.pagination',
//     status: '.page-load-status',
//   })
// })
// $(document).on("turbolinks:load", function() {
//   if(!$("nav ul.pagination")[0]) {
//     $(".loadmore-btn").hide();
//   }
// })

// var jscrollOption = {
//   loadingHtml: '読み込み中', // 記事読み込み中の表示、画像等をHTML要素で指定することも可能
//   autoTrigger: true, // 次の表示コンテンツの読み込みを自動( true )か、ボタンクリック( false )にする
//   padding: 20, // autoTriggerがtrueの場合、指定したコンテンツの下から何pxで読み込むか指定
//   nextSelector: 'a.jscroll-next', // 次に読み込むコンテンツのURLのあるa要素を指定
//   contentSelector: '.jscroll' // 読み込む範囲を指定、指定がなければページごと丸っと読み込む
// }
// $('.jscroll').jscroll(jscrollOption);

$(document).on('turbolinks:load', function() {
  $('.jscroll').jscroll({
    // 追加する要素
    contentSelector: '.user-cards', 
    // 次ページのリンク
    nextSelector: 'span.next:last a',
    // 読み込み中の表示
    loadingHtml: '読み込み中',
    // 次の表示コンテンツの読み込みを自動( true )か、ボタンクリック( false )にする
    autoTrigger: true, 
    // autoTriggerがtrueの場合、指定したコンテンツの下から何pxで読み込むか指定
    padding: 20, 
  });
});

// $(document).on('turbolinks:load', function () {
//   $('.user-cards').infiniteScroll({
//     path: "nav.pagination a[rel=next]",
//     append: ".card-index",
//     hideNav: '.pagination',
//     history: false,
//     prefill: true,
//     status: '.page-load-status'
//   })
// });