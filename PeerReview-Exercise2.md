# Code Review for Programming Exercise 1 #

## Solution Assessment ##

## Peer-reviewer Information

* *name:* [Calvin Yee] 
* *email:* [cycyee@ucdavis.edu]

### Description ###

To assess the solution, you will be choosing ONE choice from unsatisfactory, satisfactory, good, great, or perfect. Place an x character inside of the square braces next to the appropriate label.

The following are the criteria by which you should assess your peer's solution of the exercise's stages.

#### Perfect #### 
    Cannot find any flaws concerning the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    A major flaw and some minor flaws.

#### Satisfactory ####
    A couple of major flaws. Heading towards a solution, however, did not fully realize the solution.

#### Unsatisfactory ####
    Partial work, but not really converging to a solution. Pervasive major flaws. Objective largely unmet.


### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Write Justification here.

### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Write Justification here.

### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
Write justification here.

### Stage 4 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### justification ##### 
All of the camera controllers work as expected. 
The boxes are displayed by default, and each one individually works as expected. 
All exports are present as indicated in rubric.

## Code Style ##

### Code Style Review ###

#### Style Guide Infractions ####
N/A - I have not been able to find significant code style infractions.

#### Style Guide Exemplars ####
As per the style guide, the files are organized with the same layout: variables are grouped together, inheritance and classnames are at the top, exports are above function bodies, and functions are separated by appropriate whitespace.

In files such as the speedup (stage 5), as well as the lerp variations, a lot of care has been taken to organize the codeblocks for optimal readability. These files are slightly larger and serve as an example of this student's intentional adherence to the style guide. 
Additionally, comments and separation of logical portions within each function is done consistently and facilitate ease of readability.

Each logical block within the functions, such as _process() and draw_logic(), has concise comments and whitespace for clear separation.

The case usage for each script is correct, and each class is named with the correct casing as well.


## Best Practices ##

### Best Practices Review ###

#### Best Practices Infractions ####
N/A - None of the best practices decisions warrant a violation.

#### Best Practices Exemplars ####
The decisions are mainly relegated to the _process and draw_logic functions in each Camera Controller, but nonetheless the code in these functions adheres to best practices closely.

The similarity in draw_logic between the speedup.gd and auto_scroll.gd scripts indicates high reusability, given that the drawing requirements are so similar.

Additionally, each function is highly modular and separates different functionality into its appropriate functions/files. A good example of this is in the speedup.gd, where a separation of the rectangle drawing logic is useful for the multiple boxes that need to be drawn (instead of reusing it).

Variable names clearly indicate the intent/usage of each variable.

Scope of variables is appropriately minimized.

Overall, this code adheres very closely to ideal best practices, there is ample optimization and modularity.

