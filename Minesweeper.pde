

import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    textSize(12);
    
    // make the manager
    Interactive.make(this);
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int rows = 0; rows < NUM_ROWS; rows++)
    {
        for(int columns = 0; columns < NUM_COLS; columns++)
        {
            buttons[rows][columns] = new MSButton(rows, columns);
        }
    }

    setBombs();

    }
public void setBombs()
{
    for(int i = 0; i <= NUM_BOMBS; i++)
    {

    int bombRow = (int)(Math.random() * 20);
    int bombColumn = (int)(Math.random() * 20);

    if(!bombs.contains(buttons[bombRow][bombColumn]))
        bombs.add(buttons[bombRow][bombColumn]);
    }
}

public void draw ()
{
    background(0);
    if(isWon())
        displayWinningMessage();
    if(isBombPressed())
        displayLosingMessage();
    
}

public boolean isWon()
{
    int markedBombs = 0;
    for(int i = 0; i < bombs.size(); i++)
    {
        if(bombs.get(i).isMarked())
            markedBombs++;
    }

    if(markedBombs == bombs.size())
        return true;
    return false;

}
public boolean isBombPressed()
{
    for(int i = 0; i < bombs.size(); i++)
    {
        if(bombs.get(i).isClicked())
          return true;
    }
    return false;
}

public void displayLosingMessage()
{
    for(int i = 0; i < NUM_ROWS; i++)
    {
        for(int j = 0; j < NUM_COLS; j++)
        {
            if(bombs.contains(buttons[i][j]) && !buttons[i][j].isClicked())
                buttons[i][j].clicked = true;
        }
    }

    buttons[9][6].setLabel("D");
    buttons[9][7].setLabel("E");
    buttons[9][8].setLabel("S");
    buttons[9][9].setLabel("T");
    buttons[9][10].setLabel("R");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("Y");
    buttons[9][13].setLabel("E");
    buttons[9][14].setLabel("D");

}
public void displayWinningMessage()
{
    buttons[9][4].setLabel("P");
    buttons[9][5].setLabel("A");
    buttons[9][6].setLabel("T");
    buttons[9][7].setLabel("H");
    buttons[9][8].setLabel("");
    buttons[9][9].setLabel("C");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("E");
    buttons[9][12].setLabel("A");
    buttons[9][13].setLabel("R");
    buttons[9][14].setLabel("E");
    buttons[9][15].setLabel("D");
}


public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;

    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add(this); // register it with the manager
    }

    public boolean isMarked()
    {
        return marked;
    }

    public boolean isClicked()
    {
        return clicked;
    }
    
    
    public void mousePressed() 
    {
        if(mouseButton == LEFT)
        {
            clicked = true;  
        }
        if(mouseButton == RIGHT)
        {
            marked = !marked;
        }
        else if(countBombs(r, c) > 0)
        {
            if(isMarked() == false)
            {
                label = "" + countBombs(r, c);
            }
            
        }
        else
        {
                if(isValid(r-1, c) == true && !buttons[r-1][c].clicked)
                    buttons[r-1][c].mousePressed();
                if(isValid(r+1, c) == true && !buttons[r+1][c].clicked)
                    buttons[r+1][c].mousePressed();
                if(isValid(r, c-1) == true && !buttons[r][c-1].clicked)
                    buttons[r][c-1].mousePressed();
                if(isValid(r, c+1) == true && !buttons[r][c+1].clicked)
                    buttons[r][c+1].mousePressed();
                if(isValid(r-1, c-1) == true && !buttons[r-1][c-1].clicked)
                    buttons[r-1][c-1].mousePressed();
                if(isValid(r+1, c+1) == true && !buttons[r+1][c+1].clicked)
                    buttons[r+1][c+1].mousePressed();
                if(isValid(r-1, c+1) == true && !buttons[r-1][c+1].clicked)
                    buttons[r-1][c+1].mousePressed();
                if(isValid(r+1, c-1) == true && !buttons[r+1][c-1].clicked)
                    buttons[r+1][c-1].mousePressed();
        }
    }

    public void draw () 
    {    
        if(marked)
            fill(255, 255, 0);
        else if(clicked && bombs.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(255, 255, 255);
        else 
            fill(102, 178, 255);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);

    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int row, int col)
    {
        if(row < NUM_ROWS && row >= 0 && col < NUM_COLS && col >=0)
            return true;
        else 
            return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int i = -1; i <= 1; i++)
        {
            for(int j = -1; j <= 1; j++)
            {
                if(isValid(row + i, col + j) == true)
                {
                    if(bombs.contains(buttons[row][col]))
                        numBombs = 0;
                    if(bombs.contains(buttons[row + i][col + j]))
                        numBombs++;
                }
            }
        }
        return numBombs; 
    }
}



