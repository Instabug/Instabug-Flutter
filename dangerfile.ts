import { danger, fail, schedule, warn } from 'danger';
import collectCoverage, {ReportOptions, ReportType} from '@instabug/danger-plugin-coverage';
import * as fs from 'fs';

const hasSourceChanges = danger.git.modified_files.some((file) =>
  file.startsWith('lib/')
);
const declaredTrivial =
  !hasSourceChanges ||
  danger.github.issue.labels.some((label) => label.name === 'trivial');

// Make sure PR has a description.
async function hasDescription() {
  const linesOfCode = (await danger.git.linesOfCode()) ?? 0;
  const hasNoDescription = danger.github.pr.body.includes(
    '> Description goes here'
  );
  if (hasNoDescription && linesOfCode > 10) {
    fail(
      'Please provide a summary of the changes in the pull request description.'
    );
  }

  if (!danger.git.modified_files.includes('packages/instabug-Flutter/CHANGELOG.md') && !declaredTrivial) {
    warn(
      'You have not included a CHANGELOG entry! \nYou can find it at [CHANGELOG.md](https://github.com/Instabug/Instabug-Flutter/blob/master/CHANGELOG.md).'
    );
  }
}

schedule(hasDescription());

// Function to extract the second part of the filename using '-' as a separator
const getLabelFromFilename = (filename: string): string | null => {
  const parts = filename.split('-');
  return parts[1] ? parts[1].replace(/\.[^/.]+$/, '') : null; // Removes extension
};

console.log(JSON.stringify(getLabelFromFilename));
const files = fs.readdirSync('coverage');
let reportOptions:  ReportOptions[] = [];
for (let file of files) {
  reportOptions.push({
    label: getLabelFromFilename(file),
    type: ReportType.LCOV,
    filePath: "coverage/"+file,
    threshold: 80,
  });
}
collectCoverage(reportOptions);

