#' @inheritParams grid::curveGrob
#' @export
#' @rdname geom_segment
geom_curve <- function(mapping = NULL, data = NULL,
                       stat = "identity", position = "identity",
                       ...,
                       curvature = 0.5,
                       angle = 90,
                       ncp = 5,
                       arrow = NULL,
                       arrow.fill = NULL,
                       lineend = "butt",
                       na.rm = FALSE,
                       show.legend = NA,
                       inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomCurve,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list2(
      arrow = arrow,
      arrow.fill = arrow.fill,
      curvature = curvature,
      angle = angle,
      ncp = ncp,
      lineend = lineend,
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname ggplot2-ggproto
#' @include geom-segment.r
#' @format NULL
#' @usage NULL
#' @export
GeomCurve <- ggproto("GeomCurve", GeomSegment,
  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),
  draw_panel = function(data, panel_params, coord, curvature = 0.5, angle = 90,
                        ncp = 5, arrow = NULL, arrow.fill = NULL, lineend = "butt", na.rm = FALSE) {

    if (!coord$is_linear()) {
      warn("geom_curve is not implemented for non-linear coordinates")
    }

    trans <- coord$transform(data, panel_params)

    arrow.fill <- arrow.fill %||% trans$colour

    curveGrob(
      trans$x, trans$y, trans$xend, trans$yend,
      default.units = "native",
      curvature = curvature, angle = angle, ncp = ncp,
      square = FALSE, squareShape = 1, inflect = FALSE, open = TRUE,
      gp = gpar(
        col = alpha(trans$colour, trans$alpha),
        fill = alpha(arrow.fill, trans$alpha),
        lwd = trans$size * .pt,
        lty = trans$linetype,
        lineend = lineend),
      arrow = arrow
    )
  }
)
