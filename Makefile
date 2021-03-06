#******************************************************************************#
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: acarlson <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/12/15 14:08:57 by acarlson          #+#    #+#              #
#    Updated: 2018/12/30 23:50:35 by acarlson         ###   ########.fr        #
#                                                                              #
#******************************************************************************#

CC = clang
CFLAGS = -Wall -Wextra -Werror
DFLAGS = -Wall -Wextra -g
SRCS = srcs/
OBJDIR = .obj/
INCLUDES = -I includes/ -I libft/includes/ -I minilibx_macos/
FRAMEWORKS = -framework OpenGL -framework AppKit
FILES = main parsing line_drawing struct lst_funcs draw_image util
CFILES = $(addsuffix .c, $(FILES))
OFILES = $(addprefix $(OBJDIR), $(addsuffix .o, $(FILES)))
LIBS = -L libft/ -lft -L minilibx_macos/ -lmlx
DNAME = d_fdf
NAME = fdf

CL_CYAN = \033[0;36m
CL_GREEN = \033[0;32m
CL_RED = \033[0;31m
CL_WHITE = \033[0m

all: $(NAME)

$(NAME): $(OBJDIR) $(OFILES)
	@make -C libft/
	@make -C minilibx_macos/
	@$(CC) $(CFLAGS) $(INCLUDES) $(FRAMEWORKS) $(LIBS) $(OFILES) -o $(NAME)
	@echo "  $(CL_WHITE)+ $(NAME): Compiled $(CL_GREEN)$@$(CL_WHITE)"

clean:
	@make -C libft/ clean
	@make -C minilibx_macos/ clean
	@echo " $(shell \
	if [ -d $(OBJDIR) ]; \
	then \
		echo " $(CL_WHITE)- $(NAME) : Removing $(CL_RED)$(OBJDIR)$(CL_WHITE) with$(CL_RED)"; \
		ls $(OBJDIR) | wc -w | tr -d '[:blank:]'; echo "$(CL_WHITE)object files"; \
		rm -Rf $(OBJDIR); \
	else \
		echo " $(CL_WHITE)# $(NAME) : Nothing to clean"; \
	fi) "

fclean: clean
	@make -C libft/ fclean
	@make -C minilibx_macos/ clean
	@echo " $(shell \
	if [ -f $(NAME) ]; \
	then \
		echo " $(CL_WHITE)- $(NAME) : Removing  $(CL_RED)$(NAME)$(CL_WHITE)"; \
		rm -f $(NAME); \
	else \
		echo " $(CL_WHITE)# $(NAME): Nothing to fclean"; \
	fi) "

re: fclean all

$(addprefix $(OBJDIR), %.o): $(addprefix $(SRCS), %.c)
	@$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

$(OBJDIR):
	@echo " $(shell \
	if [ -d $(OBJDIR) ]; \
	then \
		: ; \
	else \
		mkdir $(OBJDIR); \
		echo " + $(NAME): Created  $(CL_GREEN)$(OBJDIR)$(CL_WHITE)$(CL_WHITE)"; \
	fi) "

debug:
	make -C libft/
	make -C minilibx_macos/
	$(CC) $(DFLAGS) $(INCLUDES) $(FRAMEWORKS) $(LIBS) $(addprefix $(SRCS), $(CFILES)) -o $(DNAME)

j: debug

dclean:
	rm -f $(DNAME)
	rm -rf $(DNAME).dSYM

fsan:
	make -C libft/
	make -C minilibx_macos/
	$(CC) $(DFLAGS) $(INCLUDES) $(FRAMEWORKS) $(LIBS) $(addprefix $(SRCS), $(CFILES)) -o $(DNAME) -fsanitize=address

k: dclean fclean
	rm -rf *.dSYM
