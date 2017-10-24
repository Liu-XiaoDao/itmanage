$(".tab .signup a").click(function(){
  $(this).addClass("under-line");
  $(".tab .signin a").removeClass("under-line");
  $(".tab .ldap a").removeClass("under-line");
  $("#signup-box").css("display","block");
  $("#signin-box").css("display","none");
  $("#ldap-box").css("display", "none");
  $(".form-error").css("display","none");
  return false;
});

$(".tab .signin a").click (function(){
  $(this).addClass("under-line");
  $(".tab .signup a").removeClass("under-line");
  $(".tab .ldap a").removeClass("under-line");
  $("#signup-box").css("display", "none");
  $("#signin-box").css("display", "block");
  $("#ldap-box").css("display", "none");
  $(".form-error").css("display", "none");
  return false;
});


$(".tab .ldap a").click (function(){
  $(this).addClass("under-line");
  $(".tab .signup a").removeClass("under-line");
  $(".tab .signin a").removeClass("under-line");
  $("#signup-box").css("display", "none");
  $("#signin-box").css("display", "none");
  $("#ldap-box").css("display", "block");
  $(".form-error").css("display", "none");
  return false;
});

$(".login-body .form-group .form-input").each(function(){
  $(this).focus(function(){
    $(this).next(".icon").css("color", "#444");
  });   
  $(this).blur (function(){
    $(this).next(".icon").css("color", "");
  });
});
  