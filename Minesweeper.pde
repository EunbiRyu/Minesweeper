import de.bezier.guido.*;
private final static int NUM_ROWS = 10; ///Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

int score = 0; //////

void setup ()
{
    size(400, 440);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i=0;i<NUM_ROWS;i++){
      for(int j=0;j<NUM_COLS;j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    
    setMines();
}
public void setMines()
{
    int num_mines = 5;
    while(num_mines > 0){
      int r = (int)(Math.random()*10);
      int c = (int)(Math.random()*10);
      if(!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
        System.out.println(r+", "+c);
      }
      
      num_mines--;
    }
    
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
        
    displayScore();
}
public boolean isWon()
{
  for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
      if(!buttons[i][j].isClicked() && !mines.contains(buttons[i][j])){
        return false;
      }
    }
  }
  return false;
}
public void displayLosingMessage()
{
  for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
      buttons[i][j].setLabel("X");
    }
  }
}
public void displayWinningMessage()
{
  for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
      buttons[i][j].setLabel(":D");
    }
  }
}


public void displayScore() {
    // Display score
    fill(255);
    textSize(20);
    text("Score: " + score, width / 2, height - 20);
}


public boolean isValid(int r, int c)
{
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here

    for(int x = row-1; x<=row+1; x++){
      for(int y=col-1; y<=col+1; y++){
        if(isValid(x,y)==true){
           if(mines.contains(buttons[x][y])){numMines++;}
        }
      }
    }
    if((numMines != 0)&&(mines.contains(buttons[row][col]))){
      numMines--;
    }
    
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true){
            flagged = false;
          } else {
            flagged = true;
            clicked = false;
          }
        } else if(mines.contains(buttons[myRow][myCol])){
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
          score++; /////////
        } else {
          buttons[myRow][myCol-1].mousePressed();
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
             fill(0,(int)(Math.random()*254), (int)(Math.random()*254));
            //fill( 200 );
        else 
            fill(255);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    //
    public boolean isClicked()
    {
        return clicked;
    }
}
