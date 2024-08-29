export const updateKendoDialogStyles = element => {
  if (element.length > 0) {
    let headerElement = element[0].previousSibling;
    headerElement.style.background = "lightgrey";
    headerElement.style.color = "black";
    headerElement.style.fontWeight = "600";

    let buttonsGroup = element[0].nextElementSibling;
    buttonsGroup.classList.remove("k-justify-content-stretch");
    jQuery(buttonsGroup.children[0])?.attr("data-cy", "yesConfirmation").css({ padding: "5px 20px" });
    jQuery(buttonsGroup.children[1])?.attr("data-cy", "noConfirmation").css({ padding: "5px 20px" });
  }
};

export const updateKendoGridStyles = (parentClass = "") => {
  jQuery(parentClass + " .k-grid-header span.k-icon").css({ color: "#fff" });
  jQuery(parentClass + " .k-grid-content").addClass("grid-loading");
};

export let headerCustomStyles = "background: #808080; color: #fff; border-color: #fff";
export let fullScreen = false;
export let fullScreenName = "Full Screen";

export function toggleFullScreen(tabName) {
  var tabControl = jQuery("#" + tabName);
  if (!fullScreen) {
    tabControl.attr("old_height", tabControl.css("height"));
    jQuery("header,nav,footer").hide();
    tabControl.addClass("fullscreenlayer").css("overflow", "auto").css("height", "100vh");
    jQuery("body").css("overflow", "hidden");
    fullScreen = true;
    fullScreenName = "Exit Full Screen";
    window.location.hash = "fullScreen";
  } else {
    jQuery("header,nav,footer").show();
    tabControl.removeClass("fullscreenlayer").css("overflow", "");
    jQuery("body").css("overflow", "");
    tabControl.css("height", tabControl.attr("old_height"));
    fullScreen = false;
    fullScreenName = "Full Screen";
    window.location.hash = "";
  }
}

window.onhashchange = function () {
  if (fullScreen && window.location.hash != "#fullScreen") {
    toggleFullScreen();
  }
};
