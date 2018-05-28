'use babel';

import { Settings } from './config';

export default {
  config: Settings,
  subscriptions: null,
  
  activate(state) {
    this.handlePaneChanged();
    this.handleSettingChanged();
  },
  
  deactivate() {
    
  },
  
  handlePaneChanged() {
    atom.workspace.onDidStopChangingActivePaneItem((editor) => {
      this.loadGrammar(editor);
    });
  },
  
  handleSettingChanged() {
    atom.config.observe('language-dotenv.dotenvFileNames', (newValue) => {
      this.loadGrammar(atom.workspace.getActiveTextEditor());
    });
  },
  
  loadGrammar(editor) {
    if (!editor || !editor.getBuffer) { return; }
    
    var buffer = editor.getBuffer();
    if (!buffer.file || !buffer.file.path) { return; }
    
    var filename = buffer.getBaseName();
    if (atom.config.get('language-dotenv.dotenvFileNames').includes(filename)) {
      atom.textEditors.setGrammarOverride(editor, 'source.dotenv');
    }
  }
};
