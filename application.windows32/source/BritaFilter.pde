//Whip the yolo till my hand hurts

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.effects.*;
import java.io.File;   
import javax.swing.JFileChooser;
import ddf.minim.ugens.*;

float GUIthresh = 0.67;
Minim minim;
PImage logo;
PImage hpfhand;
PImage lpfhand;
PFont small;
PFont huge;
int hugefont = 80;
AudioOutput out;
AudioPlayer song;
AudioSignal as;
float pitchmu = 1;
ddf.minim.analysis.FFT fft;
int spectrumScale = 5; // pixels per FFT bin
IIRFilter fil;
LowPassFS fil2;
float centerFreq;
float bandwidth;
float height3;
String filename;
int filtype = 1;
JFileChooser fileChooser;

void setup()
{
       fileChooser = new JFileChooser();

  size(600, 300, P3D);
  logo = loadImage("logo.png");
  hpfhand =loadImage("hpf.png");
  lpfhand = loadImage("lpf.png");
  minim = new Minim(this);
    openSong();
  small = createFont("Arial",14,true);
  huge = createFont("Arial", 12);
 
  
  out = minim.getLineOut(Minim.STEREO);
  
  fft = new ddf.minim.analysis.FFT(out.bufferSize(), out.sampleRate());
  fft.window(ddf.minim.analysis.FFT.HAMMING);
  

  
  centerFreq = 440;
  bandwidth = 20;
  
  fil = new LowPassFS(centerFreq, song.sampleRate());
  song.addEffect(fil);
}
 
void draw()
{
  background(0);
  stroke(154,202,235);
  
  image(logo, width/2-logo.width/2, 0, logo.width/2, logo.height/2);
  

  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    float x1 = map(i, 0, out.bufferSize(), 0, width);
    float x2 = map(i+1, 0, out.bufferSize(), 0, width);
    line(x1, 140 + song.left.get(i)*50, x2, 140 + song.left.get(i+1)*50);
   // line(x1, 150 + song.right.get(i)*50, x2, 150 + song.right.get(i+1)*50);
  }
  
  
  fft.forward(out.mix);
  fft.forward(song.mix);
 // fill(100,400,255);
  noStroke();
  /*
  for(int i = 0; i < fft.specSize(); i++)
  {
    // draw the line for frequency band i using dB scale
    float val = 4*(20*((float)Math.log10(fft.getBand(i))));
    rect(i*spectrumScale, height, spectrumScale, -Math.round(val));
  }
  */
  
  height3 = height/3;
  for(int i = 0; i < fft.specSize(); i++)
    {


      float valcu = 4*(20*((float)Math.log10(fil.frequency())));
      float val = 4*(20*((float)Math.log10(fft.getBand(i))));
      fill(255,0, 255*i/fft.specSize());
      if (song.isPlaying())
      rect(i*spectrumScale, height+30, spectrumScale, -Math.round(val));
    
     //line(i, height3, i, height3 - fft.getBand(i)*spectrumScale);
      //line(i, height, i, height - val);
      //float x1 = map(i, 0, val, 0, width);
    //float x2 = map(i+1, 0, val, 0, width);
    //line(i, Math.round(val), i+1, Math.round(val));
    
    
      
    }
      String filstr = "";
       switch(filtype){
         case 1: filstr = "LOWPASS"; break;
         case 0: filstr = "HIGHPASS"; break;
         case 2: break;
       }
       
       fill(255);  textFont(small,14);                  // STEP 3 Specify font to be used

       
       text(filstr +" Cutoff @ " + Math.round(fil.frequency()) + " Hz", mouseX*(int(mouseX<(GUIthresh*width))) + int(mouseX>(GUIthresh*width))*width*GUIthresh, mouseY  );
        
        fill(255);
        
       text("Instructions: Press H/L for\n HPF/LPF, move mouse to\nchange f_cutoff, [/] to skip,\n O to open a new track,\n space to play/pause", width*0.5, 35);

       if (filtype == 1) {
         image(lpfhand, width-lpfhand.width/3 -10, 10, lpfhand.width/3, lpfhand.width/3);

       }
       
       else if (filtype == 0) {
         image(hpfhand, width-hpfhand.width/3 -10, 10, hpfhand.height/3, hpfhand.width/3);
 
       }


}

void mouseMoved()
{
  centerFreq = map(mouseX, 0, width, 0, song.sampleRate()/(spectrumScale));
  fil.setFreq(centerFreq);
  float bpfQ = 100 - map(mouseY, 0, height, 0, 98);  // lowest Q is 100-98 = 2;
 // bandwidth = centerFreq/bpfQ;
  //float bpfQ = 100 - map(mouseY, 0, height, 0, 98);
  //fil.setBandWidth(bandwidth);
  

}
 
 
void keyPressed() /// NOT USING
{
  SineWave mySine;
  Osc osc1;

  float pitch = 0;
  
 // if (key == )
  
  //else if (key == )
  
  switch(key) {
    
    
    /*case 'a': pitch = 262; break;
    case 'w': pitch = 277; break;
    case 's': pitch = 294; break;
    case 'e': pitch = 311; break;
    case 'd': pitch = 330; break;
    case 'f': pitch = 349; break;
    case 't': pitch = 370; break;
    case 'g': pitch = 392; break;
    case 'y': pitch = 415; break;
    case 'h': pitch = 440; break;
    case 'u': pitch = 466; break;
    case 'j': pitch = 494; break;
    case 'k': pitch = 523; break;
    case 'o': pitch = 554; break;
    case 'l': pitch = 587; break;
    case 'p': pitch = 622; break;
    case ';': pitch = 659; break;
    */
  }
  
   if (pitch > 0) {
      osc1 = new Osc(pitch*pitchmu, 0.2, "saw");
      
   }
   
   
   
   
   
   
}
void keyReleased()
{
   //Pitch Controls
  if (key == 'z' && pitchmu > 0.25) {
    pitchmu = pitchmu/2;
  } else if (key == 'x' && pitchmu < 8) {
    pitchmu = pitchmu*2;
  }
  else if (key == 'h') { //hp
      fil = new HighPassSP(centerFreq, song.sampleRate());
      filtype = 0;
      song.clearEffects();
        song.addEffect(fil);


  }
  else if (key == 'l') { // lp
     fil = new LowPassFS(centerFreq, song.sampleRate());
     filtype = 1;
           song.clearEffects();

       song.addEffect(fil);

  }
   else if (key == ' ') { //hp
      
       if (song.isPlaying())
         song.pause();
       else
         song.play();
       


  }
  
  else if (key == '[') {
        song.skip(-3000);

   song.rewind(); 
  }
  else if (key == ']') {
          song.skip(3000);

  }
  
  else if (key == 'o') { //hp
       song.close();
       setup();
     
  }
  
}

int openSong() {
  
   if (song != null)
     System.out.println("hi");
  fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
  int result = fileChooser.showOpenDialog(null);
    File selectedFile = fileChooser.getSelectedFile();
    //System.out.println("Selected file: " + selectedFile.getAbsolutePath());
    filename = selectedFile.getAbsolutePath();
   song = minim.loadFile(filename, 1024);
  song.loop(); 

  return result;
}



void stop()
{
  out.close();
  minim.stop();
 song.close();
  super.stop();
}


class Osc implements AudioSignal
{
     private float freq;
     private float level;
     private float alph;
     private Oscillator exc;
     
     Osc(float pitch, float amplitude, String waveform)
     {  
         freq = pitch;
         level = amplitude;
         exc = new SineWave(freq, level, out.sampleRate());
         alph = 0.9;  // Decay constant for the envelope
         out.addSignal(this);
         
         if (waveform.equals("sine"))
         {
           exc = new SineWave(freq, level, out.sampleRate());
         }
         else if (waveform.equals("saw"))
         {
            exc = new SawWave(freq, level, out.sampleRate());

         }
         else {
          exc = new PulseWave(freq, level, out.sampleRate());
           
         }
         
     }

     void updateLevel()
     {
         // Called once per buffer to decay the amplitude away
         level = level * alph;
         exc.setAmp(level);
         
         if (level < 0.01) {
             out.removeSignal(this);
         }
         // this will lead to destruction of the object, since the only active 
         // reference to it is from the LineOut
     }
     
     void generate(float [] samp)
     {
         // generate the next buffer's worth of sinusoid
         exc.generate(samp);
         // decay the amplitude a little bit more
         updateLevel();
     }
     
    // AudioSignal requires both mono and stereo generate functions
    void generate(float [] sampL, float [] sampR)
    {
        exc.generate(sampL, sampR);
        updateLevel();
    }

}