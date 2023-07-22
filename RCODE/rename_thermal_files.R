


input_path_term <- "G:/O meu disco/Alqueva/Alqueva_20230720/term_raw"

fl_term <- list.files(input_path_term, full.names = TRUE, pattern = ".tif$")

input_path_vis <- "G:/O meu disco/Alqueva/Alqueva_20230720/vis"

fl_vis <- list.files(input_path_vis, full.names = TRUE, pattern = ".jpg$")

mod_names <- gsub("vis","term_raw",fl_vis)
mod_names <- gsub("jpg","tif",mod_names)

head(fl_term)
head(mod_names)


file.rename(fl_term, mod_names)