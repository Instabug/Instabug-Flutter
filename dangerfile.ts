import { danger, fail, schedule, warn } from 'danger';
import collectCoverage, { ReportType } from '@instabug/danger-plugin-coverage';

const hasSourceChanges = danger.git.modified_files.some((file) =>
  file.startsWith('lib/')
);
const hasModulesChanges = danger.git.modified_files.some((file) => file.startsWith('lib/src/modules/'));

const declaredTrivial =
  !hasSourceChanges ||
  danger.github.issue.labels.some((label) => label.name === 'trivial');

// Make sure PR has a description.
async function hasDescription() {
  const linesOfCode = (await danger.git.linesOfCode()) ?? 0;
  const hasNoDescription = danger.github.pr.body.includes(
    '> Description goes here'
  );
  const hasNoExample = danger.github.pr.body.includes('> Example of how to call it');

  if (hasNoDescription && linesOfCode > 10) {
    fail(
      'Please provide a summary of the changes in the pull request description.'
    );
  }
    if (hasNoExample && linesOfCode > 10 && hasModulesChanges) {
      warn('Please provide example of how to call it.');
    }
  if (!danger.git.modified_files.includes('CHANGELOG.md') && !declaredTrivial) {
    warn(
      'You have not included a CHANGELOG entry! \nYou can find it at [CHANGELOG.md](https://github.com/Instabug/Instabug-Flutter/blob/master/CHANGELOG.md).'
    );
  }
}

schedule(hasDescription());

collectCoverage({
  label: 'Dart',
  type: ReportType.LCOV,
  filePath: 'coverage/lcov.info',
  threshold: 80,
});
