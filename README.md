# The Maximax Minimax Quotient Theorem

This repository contains the MATALB codes used in my paper [The Maximax Minimax Quotient Theorem](https://link.springer.com/article/10.1007/s10957-022-02008-z) also available on [ArXiv](https://arxiv.org/abs/2104.15025).


If $X$ and $Y$ are two polytopes in $\mathbb{R}^n$ with $-X \subseteq interior(Y)$, $\dim X = 1$, $\partial X = \{x_1, x_2\}$ with $x_2 \neq 0$ and $\dim Y = n$, then $\underset{d\, \in\, \mathbb{S}}{\max}\ r_{X,Y}(d) = \max \big\{ r_{X,Y}(x_2), r_{X,Y}(-x_2) \big\}$.

$$r_{X,Y}(d) := \frac{\underset{x\, \in\, X,\ y\, \in\, Y}{\max} \big\{ \|x + y\| : x + y \in \mathbb{R}^+d \big\} }{ \underset{x\, \in\, X}{\min} \big\{ \underset{y\, \in\, Y}{\max} \big\{ \|x + y\| : x + y \in \mathbb{R}^+d \big\} \big\} }.$$


You can also watch the video on [Youtube](https://www.youtube.com/watch?v=rjKzHyDJX40) 
[![Maximax Minimax video]({video_snap.png})](https://www.youtube.com/watch?v=rjKzHyDJX40 "title")



## File Structure
---
- The code `Maximax_minimax_video.m` generates a video illustrating the principle of the proof of the Theorem. 
- The function `circular_arrow.m` is taken from [MathWorks file exchange](https://www.mathworks.com/matlabcentral/fileexchange/59917-circular_arrow).



## Citation
---
```
@article{bouvier2022maximax,  
  title = {The Maximax Minimax Quotient Theorem},   
  author = {Jean-Baptiste Bouvier and Melkior Ornik},      
  journal = {Journal of Optimization Theory and Applications},
  year = {2022},
  volume = {192},
  pages = {1084 -- 1101},
  publisher = {Springer},
  doi = {10.1007/s10957-022-02008-z}
}
```


## Contributors
---
- [Jean-Baptiste Bouvier](https://jean-baptistebouvier.github.io/)
- [Melkior Ornik](https://mornik.web.illinois.edu/)
